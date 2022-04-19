class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart_item, only: %i[update destroy]

  def create
    authorize CartItem
    
    @cart_item = current_user.cart.cart_items.new(cart_item_params)

    respond_to do |format|
      format.json do
        if @cart_item.save
          render json: @cart_item
        else
          render json: { message: @cart_item.errors.full_messages.join("; ") }, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    respond_to do |format|
      format.json do
        if @cart_item.update(quantity: params[:cart_item][:quantity].to_i)
          render json: @cart_item
        else
          render json: { message: @cart_item.errors.full_messages.join("; ") }, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      format.json do 
        render json: @cart_item.destroy
      end
    end
  end

  private

  def load_cart_item
    @cart_item = authorize CartItem.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:id, :item_id, :quantity)
  end
end