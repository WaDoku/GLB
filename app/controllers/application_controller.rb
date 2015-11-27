class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :layout_by_resource
  before_filter :authenticate_user!

  protected

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
