class PostPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all.order("created_at desc")
      else
        scope.where(user_id: user.id).order("created_at desc")
      end
    end
  end
end