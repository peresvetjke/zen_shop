class CartItemPolicy < ApplicationPolicy
  def index?
    !!user
  end

  def create?
    !!user
  end
  
  def update?
    user&.owner_of?(record.cart)
  end

  def destroy?
    user&.owner_of?(record.cart)
  end
end