class Admin::PostsController < Admin::BaseController
  def index
    @filterrific = initialize_filterrific(
        policy_scope(Post),
        params[:filterrific],
        # available_filters: [:search, :with_cycle_id],
        :select_options => {
            with_category_id: Category.options_for_select
        }
    ) or return
    @records = @filterrific.find.order("created_at desc").page params[:page]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
  end

  def create
    resource.update(model_params)
    resource.user_id = current_user.id
    resource.content.gsub! '<pre>', '<p>'
    resource.content.gsub! '</pre>', '</p>'
    if resource.save
      # redirect_to admin_posts_path
    else
      render :new
    end
  end

  def edit
    render "new"
  end

  def update
    create
  end

  def destroy
    resource.destroy
    redirect_to admin_posts_path
  end

  def resource
    super("Post")
  end

  def model_params
    params.require(:post).permit(:title, :content, :title_en, :content_en, :title_jp, :content_jp, :photo, :tag_list, :static_id, :category_ids => [])
  end

  def ajax_delete_multiple_post
    params["post_ids"].each do |id|
      p = Post.find_by(id: id)
      if p.present?
        p.destroy
      end
    end
    render :js => "window.location = '/admin/posts'"
  end
end
