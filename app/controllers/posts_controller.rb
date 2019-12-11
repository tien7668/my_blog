class PostsController < ApplicationController
  def index
    @filterrific = initialize_filterrific(
        Post,
        params[:filterrific],
        # available_filters: [:search, :with_cycle_id],
        :select_options => {
            with_category_id: Category.options_for_select
        }
    ) or return
    @records = @filterrific.find.order("created_at desc").page params[:page]
    @recent_posts = Post.order("created_at desc").limit(3)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @post = Post.friendly.find(params[:id])
    # temp = Post.tagged_with(@post.tag_list, :any => true)
    @nextPosts = Post.where('updated_at > ?',@post.updated_at).order("updated_at asc").limit(1)
    @prevPosts = Post.where('updated_at < ?',@post.updated_at).order("updated_at desc").limit(1)

  end

end
