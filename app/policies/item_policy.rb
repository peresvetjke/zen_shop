class ItemPolicy < ApplicationPolicy
  def show?
    true
  end

  def search?
    true
  end

  def subscribe?
    !!user
  end
end