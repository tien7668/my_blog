class UserPolicy < AdminPolicy

  def index?
    user.admin?
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    user.admin?
  end

  def new?
    create?
  end

  def update?
    user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end

end