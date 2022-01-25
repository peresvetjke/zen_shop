class UserPolicy < ApplicationPolicy
  def show?
    !!user
  end
end