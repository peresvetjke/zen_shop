class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart, only: %i[new create]
  before_action :load_previous_address, only: :new
  before_action :load_default_address, only: :new
  before_action -> { authorize Order }, only: %i[new create]

  def new
  end

  def create
    @order = current_user.orders.new(order_params)
    
    if Order.post_from_cart!(@order)
      redirect_to @order, notice: t(".message")
    else
      @order.valid?
      render :new
    end
  end

  def show
    @order = authorize Order.find(params[:id])
  end

  def index
    @orders = policy_scope(Order)
  end

  private

  def order_params
    params.require(:order).permit(:delivery_type,
      delivery_attributes: [:type],
      address_attributes: [:country, :postal_code, :region_with_type, :city_with_type, :street_with_type, :house, :flat])
  end

  def load_cart
    @cart = current_user.cart
  end

  def load_previous_address
    @previous_address = current_user.orders&.last&.address
  end

  def load_default_address
    @default_address = current_user.address
  end
end