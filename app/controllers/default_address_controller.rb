class DefaultAddressController < ApplicationController
  before_action :authenticate_user!
  before_action -> { authorize Address }
  
  def create
    @address = Address.find_or_initialize_by(default_address_params)
    @default_address = current_user.build_default_address(address: @address)

    if @address.save && @default_address.save
      redirect_to account_path, notice: t("default_addresses.update.message")
    else
      render :new
    end
  end

  private

  def default_address_params
    params.require(:default_address).permit(:country, :postal_code, :region_with_type, :city_with_type, :street_with_type, :house, :flat)
  end
end