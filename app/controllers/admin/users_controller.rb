module Admin

  def self.policy_class
    UserPolicy
  end

  class UsersController < BaseController
    before_action do
      authorize Admin, :access?
    end
    def index
      @records = User.all
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
      @record.role = 1
      @record.password = user_params["username"]
      @record.password_confirmation = user_params["username"]
      if @record.save
        redirect_to admin_users_path
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
      resource.update(user_params)
      if resource.save
        redirect_to admin_users_path
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
      params[:id].present? ? User.friendly.find(params[:id]) : User.new
    end

    def user_params
      params.require(:user).permit(:name, :username, :password, :password_confirmation, :email, :role)
    end

  end

end
