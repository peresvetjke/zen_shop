class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    authorize User
    
    @user = current_user
    @default_address = @user.address
  end
end