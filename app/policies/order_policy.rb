class OrderPolicy < ApplicationPolicy
  def new?
    create?
  end

  def create?
    !!user
  end

  def show?
    user&.owner_of?(record)
  end
end