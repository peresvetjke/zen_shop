class ApplicationController < ActionController::Base
  include Pundit::Authorization
  
  before_action :load_categories

  private
  
  def load_categories
    @categories = Category.all
  end
end
