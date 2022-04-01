class Admin::CategoriesController < Admin::BaseController
  before_action :authenticate_user!
  before_action :load_category, only: %i[show edit update destroy]
  before_action -> { authorize([:admin, Category]) }

  def index
    skip_policy_scope
  end

  def show
  end

  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.turbo_stream { render turbo_stream: turbo_stream.replace("notice", partial: "shared/notice", locals: {notice: t('.message')}) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_category", partial: "admin/categories/form", locals: { category: @category }) }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace("notice", partial: "shared/notice", locals: {notice: t('.message')}) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@category, partial: "admin/categories/form", locals: { category: @category }) }
      end
    end
  end

  def destroy
    respond_to do |format|
      format.turbo_stream { 
        @category.destroy
        render turbo_stream: turbo_stream.replace("notice", partial: "shared/notice", locals: {notice: t('.message')}) 
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