class Admin::OrdersController < Admin::BaseController
  before_action :authenticate_user!
  before_action :load_order, only: %i[show edit update]
  
  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      format.html do
        if @order.update(status: Order.statuses.key(order_params[:status].to_i))
          redirect_to admin_order_path(@order)
        else
          render :edit, notice: @order.errors.full_messages.join("; ")
        end
      end
    end
  end

  private

  def load_order
    authorize @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end