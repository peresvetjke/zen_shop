class Admin::CategoriesController < Admin::BaseController
  before_action :authenticate_user!
  before_action :load_category, only: %i[show edit update destroy]
  before_action -> { authorize Category }

  def index
    skip_policy_scope
  end

  def show
  end

  def new
  end

  def create
    @category = Category.new(category_params)
    
    if @category.save
      redirect_to admin_category_path(@category), notice: I18n.t("categories.create.message")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_category_path(@category), notice: I18n.t("categories.update.message")
    else
      render :edit
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