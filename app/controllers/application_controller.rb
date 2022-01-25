class ApplicationController < ActionController::Base
  include Pundit
  
  before_action :load_categories
  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
  
  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    respond_to do |format|
      format.json { render json: { message: "#{policy_name}.#{exception.query}", status: :forbidden } }
      format.html { 
        flash[:error] = "#{policy_name}.#{exception.query}"
        redirect_to(request.referrer || root_path)
      }
    end
  end

  def load_categories
    @categories = Category.all
  end
end
