class Admin::CategoriesController < Admin::BaseController
  before_action :authenticate_user!
  before_action :load_category, only: %i[show edit update destroy]
  before_action -> { authorize Category }

  def index
    skip_policy_scope
  end

  def show
  end

  def create
    # byebug
    @category = Category.new(category_params)
    
    respond_to do |format|
      format.json {
        if @category.save
          render json: { category: @category.to_json, message: t('.message') }
        else
          render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
        end
      }
    end
  end

  def update
    respond_to do |format|
      format.json {
        if @category.update(category_params)
          render json: { category: @category.to_json, message: t('.message') }
        else
          render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
        end
      }
    end
  end

  def destroy
    respond_to do |format|
      format.json { 
        render json: { category: @category.destroy, message: t('.message') }
      }
    end
  end

  private

  def load_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:title)
  end
end