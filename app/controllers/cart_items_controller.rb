class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart_item, only: %i[update destroy]

  def create
    @cart_item = current_user.cart.cart_items.new(cart_item_params)
    if @cart_item.save 
      redirect_to cart_path, notice: t(".message")
    else
      redirect_to item_path(@cart_item.item), notice: @cart_item.errors.full_messages.join("; ")
    end
  end

  def update
    if @cart_item.change_amount_by!(params[:cart_item][:amount].to_i)
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