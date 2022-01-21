class ItemsController < ApplicationController
  before_action :load_items, only: :index
  before_action :load_item, only: :show

  def index
  end
  
  def show
  end
  
  private

  def load_items
    @items = Item.all
    @items = @items.where(category: params[:category_id]) if params[:category_id]
  end

  def load_item
    @item = Item.find(params[:id])
  end
end