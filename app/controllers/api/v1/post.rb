module API
  module V1
    class Post < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore
      resource :post do
        desc "List posts"
        params do

        end
        get "list" do
              posts = ::Post.includes(comments: :user).all
              { error: false, data: posts.as_json(include: {comments: {include: :user}} ) }
        end
      end
    end
  end
end