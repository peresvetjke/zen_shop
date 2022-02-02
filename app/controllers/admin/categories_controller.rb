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
    @category = Category.new(category_params)
    
    format.json {
      if @category.save
        render json: { category: @category.to_json }
      else
        render json: { errors: @category.errors }
      end
    }
  end

  def update
    respond_to do |format|
      format.json {
        if @category.update(category_params)
          render json: { category: @category.to_json }
        else
          render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
        end
      }
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: I18n.t("categories.destroy.message")
  end

  private

  def load_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:title)
  end
end