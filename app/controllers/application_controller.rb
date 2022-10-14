# frozen_string_literal: true

# This is application controller
class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActionController::RoutingError, with: :render404
  rescue_from ActiveRecord::RecordNotFound, with: :render404

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :initialize_session
  before_action :set_cart

  $val = 0

  private

  def initialize_session
    session[:cart] ||= []
  end

  def set_cart
    @cart = Product.find(session[:cart])
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :avatar) }
  end

  def user_not_authorized
    flash[:alert] = I18n.t(:not_authorized)
    redirect_back(fallback_location: root_path)
  end

  def render404
    render file: Rails.root.join('public/404.html'), status: :not_found
  end
end
