class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart, only: %i[new create]

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
    @order = Order.find(params[:id])
  end

  def index
    @orders = current_user.orders
  end

  private

  def order_params
    params.require(:order).permit(order_items_attributes: [:id, :item_id, :unit_price, :quantity, :_destroy])
  end

  def load_cart
    @cart = current_user.cart
  end
end