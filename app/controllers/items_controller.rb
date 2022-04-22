class ItemsController < ApplicationController
  before_action :authenticate_user!, only: :subscribe
  before_action :load_item, only: %i[show subscribe]
  before_action :load_cart_items, only: %i[index show]
  before_action :load_subscriptions, only: %i[index show]
  before_action :load_reviews, only: :show
  before_action -> { authorize Item }, except: :index

  def index
    skip_policy_scope

    if params[:query].present?
      @items = Item.search(params[:query])
      @heading = "Search results"
    elsif params[:category_id].present?
      @items = Item.where(category: params[:category_id])
      @heading = "#{Category.find(params[:category_id]).title}"
    else
      @items = Item.all
    end

    @items = @items.includes([:category, :reviews, :stock])
  end
  
  def show
  end

  def search
    @items = Item.search(params[:query])
    @meta = category_dict(@items).merge(price_dict(@items))
  end

  def subscribe
    respond_to do |format|
      format.json { render json: { message: current_user.subscribe!(item: @item) } }
    end
  end

  private

  def load_item
    @item = Item.find(params[:id])
  end

  def load_reviews
    @reviews = @item.reviews
  end

  def load_subscriptions
    @subscribed_item_ids = current_user&.subscriptions&.map(&:item_id)
  end

  def load_cart_items
    @cart_items = current_user&.cart&.cart_items.as_json
  end
end