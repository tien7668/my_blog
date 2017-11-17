module API
  module V1
    class Post < Grape::API
      version 'v1'
      format :json
      resource :post do
        desc "List posts"
        params do
          optional :search, :type => String, :desc => "search word"
        end
        get "list" do
          if params[:search].present?
            posts = ::Post.where("lower(title) like ? ","%#{params[:search].downcase }%" ).or(::Post.where("lower(content) like ? ","%#{params[:search].downcase }%" ))
          else
            posts = ::Post.includes(comments: :user).all
          end
              { error: false, data: posts.as_json(include: {comments: {include: :user}} ) }
        end
      end
    end
  end
end