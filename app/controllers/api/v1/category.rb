class API::V1::Category < Grape::API
  version 'v1'
  format :json
  before do
    params[:per_page] = 100
    params[:offset] = 0
  end
  resource :category do
    desc "List categories"
    params do
    end
    get "getList" do
      authenticate!
      success(::Category.all)
    end

    desc "Get Category by id"
    params do
      requires :id, :type => Integer, :desc => "Cat id"
    end
    get "getCategory" do
      authenticate!
      success(::Category.find_by({id: params[:id]}))
    end

    desc "Create/Update Category"
    params do
      requires :category_id, :type => Integer
      requires :name, :type => String
    end
    post "updateCategory" do
      authenticate!
      attr = {name: params[:name]}
      if params[:category_id]
        cat = ::Category.find_by({id: params[:category_id]})
        raise TT::Error.new('RECORD_EXIST', 'Account not exists') unless cat.present?
        raise TT::Error.new('RECORD_EXIST', ' Name exists') if params[:name] != cat.name && ::Category.find_by({name: params[:name]}).present?
        cat.update(attr)
      else
        cat = ::Category.create(attr)
      end
      success
    end

  end
end