class ItemsController < ApplicationController
  before_action :authenticate_user!, only: :subscribe
  # before_action :load_items, only: :index
  before_action :load_item, only: %i[show subscribe]
  before_action :load_reviews, only: :show
  # before_action :set_meta, only: :index
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
      # @heading = "Catalogue"
    end

    @meta = category_dict(@items).merge(price_dict(@items))
  end
  
  def show
  end

  def search
    @items = Item.search(params[:query])
    @meta = category_dict(@items).merge(price_dict(@items))

    # @result = Item.search(params[:query])

    # respond_to do |format|
    #   format.json { 
    #                 render json: { 
    #                                 "results" => @result, 
    #                                 "meta"    => category_dict(@result)
    #                                               .merge(price_dict(@result)) 
    #                              } 
    #               }
    # end
  end

  def subscribe
    respond_to do |format|
      format.json { render json: { message: current_user.subscribe!(item: @item) } }
    end
  end

  private

  def load_items
    @items = Item.all
    @items = @items.where(category: params[:category_id]) if params[:category_id]
  end

  def load_item
    @item = Item.find(params[:id])
  end

  def load_reviews
    @reviews = @item.reviews
  end

  def search_params
    params.require(:search).permit(:category, :query, :page)
  end

  def category_dict(collection)
    { 
      "categories" => collection.group_by(&:category).map do |k,v| 
                        { 'id' => k.id,'title' => k.title, 'results_count' => v.count }
                      end
    } 
  end

  def price_dict(collection)
    { 
      "prices" => {
                    "min" => collection.map(&:price_cents).min,
                    "max" => collection.map(&:price_cents).max
                  }
    } 
  end

  def set_meta
    # result = Category.all
    @meta = category_dict(@items).merge(price_dict(@items))
  end
end