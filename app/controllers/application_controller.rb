# frozen_string_literal: true

# This is application controller
class ApplicationController < ActionController::Base
  include Pundit::Authorization # includin pundit authorization code
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized # else case for pundit authorization code
  before_action :configure_permitted_parameters, if: :devise_controller? # some extra param to devise controller(avatar)
  before_action :initialize_session # initialize session (storing in the form of cookies on browser)
  before_action :load_cart # memories the products in the cart by using session of user.
  rescue_from ActionController::RoutingError, with: :render404
  rescue_from ActiveRecord::RecordNotFound, with: :render404

  private

  def initialize_session
    session[:cart] ||= [] # safe navigation operator
  end

  def load_cart
    @cart = Product.find(session[:cart]) # load cart if it contains any product(product.id's)
  end

  protected

  # for devise extra params(avatar)
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :avatar) }
  end

  # pundit is not authorized (else function)
  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_back(fallback_location: root_path)
  end

  def render404
    render file: Rails.root.join('public/404.html'), status: :not_found
  end
end
