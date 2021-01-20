class HomeController < ApplicationController
  def index
    per_page = 4
    @records = Post.order("created_at desc").limit(per_page)
    @pages_count = Post.all.size / per_page + (Post.all.size % per_page == 0 ? 0 : 1)
    @current_page = 1
    @pages = (1.. (@pages_count < 5 ? @pages_count : 5)).to_a
  end

  def about_us
    @post = Post.find_by("static_id = 'about_us' ")
  end

  def service
  end

  def ajax_get_posts
    per_page = 4
    @page = params["page"].to_i
    @posts = Post.order("created_at desc").limit(per_page).offset((@page-1) * per_page)
    @pages_count = Post.all.size / per_page + (Post.all.size % per_page == 0 ? 0 : 1)
    if @page == 1 || @page == 2
      @pages = (1.. (@pages_count < 5 ? @pages_count : 5)).to_a
    elsif @page == @pages_count || @page == @pages_count -1
      @pages = ((@pages_count < 5 ? 1 : @pages_count - 4 ) .. @pages_count).to_a
    elsif 
      @pages = ((@page - 2) .. (@page+2)).to_a
    end 
    # render json: {pages: pages, pages_count: pages_count, posts: posts} 


    respond_to do |format|
      format.js { render :file => "./home/ajax_get_posts.js.erb" }
    end
  end

end
