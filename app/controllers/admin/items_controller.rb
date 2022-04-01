class Admin::ItemsController < Admin::BaseController
  before_action :authenticate_user!
  before_action :load_item, only: %i[show edit update destroy]
  before_action -> { authorize([:admin, Item]) }

  def index
    skip_policy_scope
    @items = Item.all
  end

  def show
  end

  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.turbo_stream { render turbo_stream: turbo_stream.replace("notice", partial: "shared/notice", locals: {notice: t('.message')}) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_item", partial: "admin/items/form", locals: { item: @item }) }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @item.update(item_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace("notice", partial: "shared/notice", locals: {notice: t('.message')}) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@item, partial: "admin/items/form", locals: { item: @item }) }
      end
    end
  end

  def destroy
    respond_to do |format|
      format.turbo_stream { 
        @item.destroy
        render turbo_stream: turbo_stream.replace("notice", partial: "shared/notice", locals: {notice: t('.message')}) 
      }
    end
  end

  private

  def load_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:title, :description, :category_id, :price, :weight_gross_gr, :image)
  end
end