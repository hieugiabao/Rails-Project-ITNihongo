class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cart

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end

  private

  def logged_in_user
    return if user_signed_in?

    session[:forwarding_url] = request.original_url if request.get?
    flash[:danger] = 'Please log in.'
    redirect_to new_user_session_path
  end

  def user_is_admin
    return if user_signed_in? && current_user.admin?

    flash[:info] = "You don't have the privilages for this action!"
    redirect_back(fallback_location: root_url)
  end

  def set_cart
    if session[:cart_id]
      cart = Cart.find_by(id: session[:cart_id])
      cart.present? ? (@current_cart = cart) : (session[:cart_id] = nil)
    end
    return unless session[:cart_id].nil?

    user_id = user_signed_in? ? current_user.id : nil

    @current_cart = Cart.create(user_id: user_id)
    session[:cart_id] = @current_cart.id
  end
end
