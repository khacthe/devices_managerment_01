class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionBorrow
  helper_method :get_list_devices, :get_size_items

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password,
      :avatar, :username]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end
end
