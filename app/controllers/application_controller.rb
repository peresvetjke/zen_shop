class ApplicationController < ActionController::Base
  include Pundit
  
  before_action :load_categories
  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
  
  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    message = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    
    respond_to do |format|
      format.json { render json: { message: message, status: :forbidden } }
      format.html { 
        flash[:notice] = message
        redirect_to(request.referrer || root_path)
      }
    end
  end

  def load_categories
    @categories = Category.all
  end

  def after_sign_in_path_for(resource)
    if resource.type == "Admin"
      admin_categories_path
    else
      super
    end
  end
end
