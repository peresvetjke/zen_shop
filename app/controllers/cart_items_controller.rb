class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart_item, only: %i[update destroy]

  def create
    authorize CartItem

    respond_to do |format|
      format.html do
        amount  = params[:cart_item][:amount].to_i
        item_id = params[:cart_item][:item_id].to_i

        @cart_item = current_user.cart.cart_items.find_or_initialize_by(item_id: item_id)

        if @cart_item.persisted? ? @cart_item.change_amount_by!(amount) : @cart_item.update(amount: amount)
          redirect_to cart_path, notice: t(".message")
        else
          redirect_to item_path(@cart_item.item), notice: @cart_item.errors.full_messages.join("; ")
        end
      end
    end
  end

  def update
    respond_to do |format|
      format.json do
        if @cart_item.change_amount_by!(params[:cart_item][:amount].to_i)
          render json: @cart_item, serializer: CartItemSerializer, root: "cart_item"
        else
          render json: { message: @cart_item.errors.full_messages.join("; ") }, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      format.json do
        render json: @cart_item.destroy, serializer: CartItemSerializer, root: "cart_item"
      end
    end
  end

  private

  def load_cart_item
    @cart_item = authorize CartItem.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:id, :item_id, :amount)
  end
end