class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart, only: %i[new create]
  before_action -> { authorize Order }, only: %i[new create]

  def new
  end

  def create
    @order = current_user.orders.new(order_params)
    if @order.save
      redirect_to @order, notice: t(".message")
    else
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
    params.require(:order).permit(order_items_attributes: [:id, :item_id, :unit_price, :quantity, :_destroy],
                                  delivery_attributes: [:id, :delivery_type, :_destroy],
                                  address_attributes: [:id, :country, :postal_code, :region_with_type, :city_with_type, :street_with_type, :house, :flat, :_destroy])
  end

  def load_cart
    @cart = current_user.cart
  end
end