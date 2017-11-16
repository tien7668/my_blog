class Admin::UsersController < Admin::BaseController
  def index
    @records = User.all
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
