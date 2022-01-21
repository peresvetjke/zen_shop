class ItemsController < ApplicationController
  before_action :load_items, only: :index
  before_action :load_item, only: :show

  def index
  end
  
  def show
  end

  def search
    @result = Item.search(params[:query])

    respond_to do |format|
      # format.html { }
      format.json { 
                    render json: { 
                                    "results" => @result, 
                                    "meta"    => category_dict(@result)
                                                  .merge(price_dict(@result)) 
                                 } 
                  }
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
end