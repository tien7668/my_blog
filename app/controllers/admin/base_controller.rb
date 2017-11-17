module Admin

  def self.policy_class
    AdminPolicy
  end

  class BaseController < ApplicationController
    layout "admin"
    # before_action :authenticate_user!
    before_action :resource, only: [:new, :edit, :show]
    before_action do
      authorize Admin, :access_user?
    end

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || new_user_session_path)
    end
  end

end
