class Admin::PostsController < Admin::BaseController
  def index

    @records = policy_scope(Post)
    # respond_to do |format|
    #   format.html
    #   format.js { render template: 'admin/meta/index.js.erb' }
    # end
  end

  def new
    respond_to do |format|
      format.js { render template: 'admin/meta/new_model' }
    end
  end

  def create
    @record = Post.new(post_params)
    @record.user_id = current_user.id
    @record.content.gsub! '<pre>', '<p>'
    @record.content.gsub! '</pre>', '</p>'
    if @record.save
      redirect_to admin_posts_path
    else
      # get_records
      # @has_record = true
      render :index
    end
  end

  def edit
    respond_to do |format|
      format.js {render template: 'admin/meta/new_model'}
    end
  end

  def update
    resource.update(post_params)
    resource.content.gsub! '<pre>', '<p>'
    resource.content.gsub! '</pre>', '</p>'
    if resource.save
      redirect_to admin_posts_path
    else
      # get_records
      # @has_record = true
      render :index
    end
  end

  def resource
    @record ||= find_record
  end

  def find_record
    params[:id].present? ? Post.friendly.find(params[:id]) : Post.new
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
