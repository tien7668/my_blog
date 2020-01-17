class API::V1::Post < Grape::API
  version 'v1'
  format :json
  include Grape::Kaminari
  before do
    params[:per_page] = 4
    params[:offset] = 0
  end
  resource :post do
    desc "List posts"
    params do
      requires :page, :type => Integer, :desc => "Page"
      optional :query, :type => String, :desc => "Search"
    end
    get "getList", jbuilder: 'posts/getList.jbuilder' do
      authenticate!
      @posts = Kaminari.paginate_array(::Post.search(params[:query]))
      # success(Kaminari.paginate_array(::Post.search(params[:query]).as_json(include: :categories)))
    end

    desc "Get Post by id"
    params do
      requires :id, :type => Integer, :desc => "User id"
    end
    get "getPost", jbuilder: 'posts/getItem.jbuilder' do
      authenticate!
      @post = ::Post.find_by({id: params[:id]})
      # success(Post.find_by({id: params[:id]}).as_json({only: [:id, :name, :username, :email, :role]}).merge({token: token}))
    end

  end
end