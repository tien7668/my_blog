module Admin

  def self.policy_class
    UserPolicy
  end

  class UsersController < BaseController
    before_action do
      authorize Admin, :access?
    end
    def index
      @records = User.all.order("users.created_at desc")
      respond_to do |format|
        format.html
        format.js { render template: 'admin/meta/index.js.erb' }
      end
    end

    def new
      respond_to do |format|
        format.js { render template: 'admin/meta/new_model' }
      end
    end

    def create
      @record = User.new(user_params)
      if params[:user][:password].blank?
        flash[:error] = "Password blank"
        redirect_to admin_users_path  and return
      elsif user_params[:password].size < 6
        flash[:error] = "Minimum password length is 6"
        redirect_to admin_users_path  and return
      elsif  (user_params[:password] != user_params[:password_confirmation])
        flash[:error] = "Password and re-password not match"
        redirect_to admin_users_path  and return
      else
        @record.role = 1
        @record.password = user_params[:password]
        @record.password_confirmation = user_params[:password]
      end
      if @record.save
        redirect_to admin_users_path
      else
        render :index
      end
    end

    def edit
      respond_to do |format|
        format.js {render template: 'admin/meta/new_model'}
      end
    end

    def update
      if params[:user][:password].blank?
        resource.update(user_params_update)
      else
        if user_params[:password].size < 6
          flash[:error] = "Minimum password length is 6"
          redirect_to admin_users_path  and return
        elsif  (user_params[:password] != user_params[:password_confirmation])
          flash[:error] = "Password and re-password not match"
          redirect_to admin_users_path  and return
        else
          resource.update(user_params)
        end
      end
      if resource.save
        redirect_to admin_users_path
      else
        render :index
      end
    end

    def resource
      @record ||= find_record
    end

    def find_record
      params[:id].present? ? User.friendly.find(params[:id]) : User.new
    end

    def user_params
      params.require(:user).permit(:name, :username, :password, :password_confirmation, :email, :role)
    end
    def user_params_update
      params.require(:user).permit(:name, :username, :email, :role)
    end
  end

end
