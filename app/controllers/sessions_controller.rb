class SessionsController < Devise::SessionsController
  layout 'login'

  def after_sign_in_path_for(resource)
    root_url+"admin"
  end
end
