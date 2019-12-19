class String
  def is_integer?
    self.to_i.to_s == self
  end
end

require 'json'
class HomeController < ApplicationController
  # def index
  #   @posts = Post.all.order("created_at desc")
  # end
  #
  # def about_us
  #   @post = Post.find_by("static_id = 'about_us' ")
  # end
  #
  # def service
  # end
  #
  # def staking
  #
  # end
  def initEpoch epoch, staker
    @book[epoch] = {"voters" => []} if @book[epoch] == nil
    @book[epoch][staker] = {"currentStake" => 0,
                            "stake" => 0,
                            "withdraw" => 0,
                            "vote" => [],
                            "representativeForNextEpoch" => [staker],
                            "representativeFor" => [staker],
                            "delegateToNextEpoch" => staker,
                            "delegateTo" => staker,
                            "readOnly" => false} if @book[epoch][staker] == nil
    if !@book[epoch][staker]["readOnly"]
      prevEpoch = getPrevEpoch staker, epoch
      @book[epoch][staker]["readOnly"] = true if epoch <= @latestEpoch
      if @book[prevEpoch] != nil && @book[prevEpoch][staker] != nil
        @book[epoch][staker]["representativeForNextEpoch"] = @book[prevEpoch][staker]["representativeForNextEpoch"].clone
        @book[epoch][staker]["representativeFor"] = @book[prevEpoch][staker]["representativeForNextEpoch"].clone
        @book[epoch][staker]["delegateToNextEpoch"] = @book[prevEpoch][staker]["delegateToNextEpoch"].clone
        @book[epoch][staker]["delegateTo"] = @book[prevEpoch][staker]["delegateToNextEpoch"].clone
        @book[epoch][staker]["stake"]=@book[prevEpoch][staker]["stake"] + @book[prevEpoch][staker]["currentStake"] - @book[prevEpoch][staker]["withdraw"]
      end
    end
  end

  def getEpoch block
    block < @startBlock ? 0 : ((block - @startBlock)/@epoch + 1)
  end

  def getPrevEpoch staker, epoch
    epoch = @latestEpoch+1 if epoch > @latestEpoch
    while epoch > 0
      epoch -=1
      break if @book[epoch] != nil &&  @book[epoch][staker] != nil
    end
    epoch
  end

  def stake block, amount, staker
    epoch = getEpoch block
    @latestEpoch = epoch if epoch > @latestEpoch

    initEpoch epoch, staker
    @book[epoch][staker]["currentStake"] += amount
    @vt += "stake #{block} #{amount} #{staker}\n"
  end

  def withdraw block, amount, staker
    epoch = getEpoch block
    @latestEpoch = epoch if epoch > @latestEpoch
    initEpoch epoch, staker
    valid = true
    if @book[epoch][staker]["currentStake"] >= amount
      @book[epoch][staker]["currentStake"] -= amount
    else
      if @book[epoch][staker]["withdraw"] + amount - @book[epoch][staker]["currentStake"] - @book[epoch][staker]["stake"] <= 0
        @book[epoch][staker]["withdraw"] += (amount - @book[epoch][staker]["currentStake"])
        @book[epoch][staker]["currentStake"] = 0
      else
        valid =false
      end
    end
    @vt += "withdraw #{block} #{amount} #{staker} #{valid ? "" : " -> skip because withdraw amount too big"}\n"
  end

  def vote block, voteid, staker
    epoch = getEpoch block
    @latestEpoch = epoch if epoch > @latestEpoch
    initEpoch epoch, staker
    @book[epoch][staker]["vote"].push voteid unless @book[epoch][staker]["vote"].include? voteid
    @book[epoch]["voters"].push staker unless @book[epoch]["voters"].include? staker
    @vt += "vote #{block} #{voteid} #{staker}\n"
  end

  def delegate block, staker, representative
    epoch = getEpoch block
    @latestEpoch = epoch if epoch > @latestEpoch
    initEpoch epoch, staker
    initEpoch epoch, representative
    initEpoch epoch, @book[epoch][staker]["delegateToNextEpoch"]

    if staker == representative
      @book[epoch][@book[epoch][staker]["delegateToNextEpoch"]]["representativeForNextEpoch"] -= [staker]
      @book[epoch][staker]["representativeForNextEpoch"].push staker if !(@book[epoch][staker]["representativeForNextEpoch"].include? staker)
      @book[epoch][staker]["delegateToNextEpoch"] = staker
    else

      # add staker to new representative
      @book[epoch][representative]["representativeForNextEpoch"] = @book[epoch][representative]["representativeForNextEpoch"].push staker if !@book[epoch][representative]["representativeForNextEpoch"].include? staker
      # remove staker from old representative
      @book[epoch][@book[epoch][staker]["delegateToNextEpoch"]]["representativeForNextEpoch"] -= [staker]

      # delegate staker to new representative
      @book[epoch][staker]["delegateToNextEpoch"] = representative
      @book[epoch][staker]["representativeForNextEpoch"] = @book[epoch][staker]["representativeForNextEpoch"] -= [staker]
    end
    @vt += "delegate #{block} #{staker} #{representative}\n"
  end

  def getReward epoch, staker
    puts "getReward #{staker} epoch #{epoch}"
    initEpoch epoch, staker
    sum = @book[epoch]["voters"].reduce(0) do |res, staker|
      # res += @book[epoch][staker]["vote"].size * @book[epoch][staker]["stake"]
      res += @book[epoch][staker]["vote"].size * (@book[epoch][staker]["stake"]- @book[epoch][staker]["withdraw"]) if @book[epoch][staker]["delegateTo"] == staker
      @book[epoch][staker]["representativeFor"].each do |item|
        initEpoch epoch, item
        res += @book[epoch][staker]["vote"].size * (@book[epoch][item]["stake"] - @book[epoch][item]["withdraw"]) if item != staker
      end
      res
    end
    stakerPoint = 0
    stakerPoint += @book[epoch][staker]["vote"].size * (@book[epoch][staker]["stake"]- @book[epoch][staker]["withdraw"]) if @book[epoch][staker]["delegateTo"] == staker
    @book[epoch][staker]["representativeFor"].each do |item|
      initEpoch epoch, item
      stakerPoint += @book[epoch][staker]["vote"].size * (@book[epoch][item]["stake"] - @book[epoch][item]["withdraw"]) if item != staker
    end
    reward = stakerPoint / sum.to_f
    @vt += "getReward #{epoch} #{staker}           -> #{stakerPoint}/#{sum}=#{reward}\n"
    puts "#{stakerPoint} #{sum} #{reward}"

  end

  def getStake epoch, staker
    initEpoch epoch, staker
    puts "getStake #{staker} epoch #{epoch}"
    stake = (epoch == 0 ? 0 : @book[epoch][staker]["stake"] - @book[epoch][staker]["withdraw"])

    puts "#{stake}"
    @vt += "getStake #{epoch} #{staker}           -> #{stake}\n"
    # puts "#{epoch == 0 ? 0 : @book[prevEpoch][staker]["stake"] + @book[prevEpoch][staker]["currentStake"] - @book[prevEpoch][staker]["withdraw"]}"
  end


  def getDelegatedStake epoch, staker
    initEpoch epoch, staker
    sum = @book[epoch][staker]["representativeFor"].inject(0) do |res, item|
      initEpoch epoch, item
      res += @book[epoch][item]["stake"] - @book[epoch][item]["withdraw"] if item != staker
      res
    end
    puts "#{epoch} #{staker} #{sum}"
    @vt += "getDelegatedStake #{epoch} #{staker}           -> #{sum}\n"
  end

  def getRepresentative epoch, staker
    initEpoch epoch, staker
    res = @book[epoch][staker]["delegateTo"]
    puts res
    @vt += "getRepresentative #{epoch} #{staker}           -> #{res}\n"
  end

  def getPoolReward epoch, staker
    initEpoch epoch, staker
    initEpoch epoch, @book[epoch][staker]["delegateTo"]
    stakerPoint = @book[epoch][staker]["stake"] - @book[epoch][staker]["withdraw"]
    poolPoint = @book[epoch][ @book[epoch][staker]["delegateTo"] ]["representativeFor"].inject(0) do |res, item|
      initEpoch epoch, item
      res += @book[epoch][item]["stake"] - @book[epoch][item]["withdraw"]
      res
    end
    res = stakerPoint/poolPoint.to_f
    @vt += "getPoolReward #{epoch} #{staker}           -> #{stakerPoint}/#{poolPoint} = #{res}\n"
  end

  def init epoch, startBlock
    @epoch = epoch
    @startBlock = startBlock
    @vt += "#{epoch} #{startBlock}\n"
  end

  def ajax_staking

    @epoch = 0, @startBlock = 0
    @book = {}
    @latestEpoch=0
    @fileName= "test1"
    @vt=""
    begin
      commands = params["commands"]
      commands.split("\n").each do |line|
        line = line.split(" ").map{|i| i.is_integer? ? i.to_i : i}
        line.length == 2 ? init(*line) : send(line[0], *line.drop(1)) if line.length > 0
      end
    rescue
      @vt = "error"
      Comment.create({user_id: User.first.id, post_id: Post.first.id, content: params["commands"]})
    end
    # raise @vt.inspect
    respond_to do |format|
      format.json { render json: {data: @vt.split("\n")} }
    end
  end
end
