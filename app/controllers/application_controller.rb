class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :layout_by_resource
  before_filter :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << :email
  end
  protected

  def record_not_found
    redirect_to root_path
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end

  end

  def admin?
    current_user.role == 'admin'
  end
end
