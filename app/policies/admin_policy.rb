class AdminPolicy < ApplicationPolicy
  def access?
    is_admin?
  end
  def access_user?
    is_admin? || is_user?
  end
end