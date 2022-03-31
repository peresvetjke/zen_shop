class AddressPolicy < ApplicationPolicy
  def create?
    !!user
  end

  def update?
    !!user
  end
end