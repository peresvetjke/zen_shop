class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_item
  before_action :load_reviews
  before_action -> { authorize Review }

  def create
    @review = current_user.reviews.new(review_params.merge({item: @item}))

    respond_to do |format|
      format.html do
        if @review.save
          redirect_to @review.item
        else
          render "items/show"
        end        
      end
    end
  end

  private

  def load_item
    @item = Item.find(params[:item_id])
  end

  def load_reviews
    @reviews = Review.where(item: @item)
  end

  def review_params
    params.require(:review).permit(:body, :rating)
  end
end