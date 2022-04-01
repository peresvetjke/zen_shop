class ImagePolicy < ApplicationPolicy
  def destroy?
    user&.admin?
  end
end