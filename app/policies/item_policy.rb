class ItemPolicy < ApplicationPolicy
  def index?
    !!user
  end

  def create?
    user&.admin?
  end

  def show?
    true
  end

  def edit?
    user&.admin?
  end

  def update?
    user&.admin?
  end

  def destroy?
    user&.admin?
  end

  def search?
    true
  end

  def subscribe?
    !!user
  end
end