class API::V1::User < Grape::API
  version 'v1'
  format :json
  include Grape::Kaminari
  before do
    params[:per_page] = 4
    params[:offset] = 0
  end
  resource :user do

    desc "User login"
    params do
      requires :email, :type => String, :desc => "Email", default: "super_admin@gmail.com"
      requires :password, :type => String, :desc => "Password"
    end
    post "login" do
      user = ::User.find_by(email: params[:email])
      raise TT::Error.new('RECORD_NOT_FOUND', 'Sorry, you have entered an invalid Email. Please try again.') unless user.present?
      raise TT::Error.new('PASSWORD_NOT_VALID', 'Sorry, It looks like the password you have entered is incorrect. Please try again.') unless user.valid_password?(params[:password])
      success(user.as_json({only: [:id, :email, :role]}).merge({token: ::JsonWebToken.encode({user_id: user.id})}))
    end

    desc "Get Info"
    post "getInfo" do
      authenticate!
      success(current_user.as_json({only: [:id, :name, :username, :email, :role]}).merge({token: token}))
    end

    desc "Get List Users"
    params do
      requires :page, :type => Integer, :desc => "Page"
      optional :query, :type => String, :desc => "Search"
    end
    get "getList" do
      authenticate!
      raise TT::Error.new('UNAUTHENTICATED', 'Sorry, Need admin permission for this action.') unless current_user.role == "admin"
      success(paginate(User.search(params[:query])))
    end

    desc "Get User by id"
    params do
      requires :id, :type => Integer, :desc => "User id"
    end
    get "getUser" do
      authenticate!
      raise TT::Error.new('UNAUTHENTICATED', 'Sorry, Need admin permission for this action.') unless current_user.role == "admin"
      success(User.find_by({id: params[:id]}).as_json({only: [:id, :name, :username, :email, :role]}).merge({token: token}))
    end
    desc "Create/Update User"
    params do
      requires :user_id, :type => Integer
      requires :name, :type => String
      requires :username, :type => String
      requires :email, :type => String
      requires :password, :type => String
      requires :password_confirmation, :type => String
    end
    post "updateUser" do
      authenticate!
      raise TT::Error.new('PASSWORD_NOT_MATCH', "Password not match") unless (params[:password] == params[:password_confirmation])
      attr = {name: params[:name],username: params[:username],email: params[:email], role: 1}
      attr = attr.merge({password: params[:password], password_confirmation: params[:password_confirmation]}) if params[:password].present?
      if params[:user_id]
        user = User.find_by({id: params[:user_id]})
        raise TT::Error.new('RECORD_EXIST', 'Account not exists') unless user.present?
        raise TT::Error.new('RECORD_EXIST', 'Email exists') if params[:email] != user.email && User.find_by({email: params[:email]}).present?
        user.update(attr)
      else
        user = User.create(attr)
      end
      success
    end


  end
end