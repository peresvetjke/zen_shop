class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart_item, only: %i[update destroy]

  def create
    current_user.cart.cart_items.create(cart_item_params)
    redirect_to cart_path, notice: t(".message")
  end

  def update
    if @cart_item.update(amount: @cart_item.amount + params[:cart_item][:amount].to_i)
      render json: @cart_item, serializer: CartItemSerializer, root: "cart_item"
    else
      render json: { message: @cart_item.errors.full_messages.join("; ") }, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @cart_item.destroy, serializer: CartItemSerializer, root: "cart_item"
  end

  private

  def load_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:id, :item_id, :amount)
  end
end