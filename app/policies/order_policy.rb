class OrderPolicy < ApplicationPolicy
  def edit?
    user&.admin?
  end

  def update?
    user&.admin?
  end

  def new?
    create?
  end

  def create?
    !!user
  end

  def show?
    user&.owner_of?(record) || user&.admin?
  end
end