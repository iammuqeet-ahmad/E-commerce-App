# frozen_string_literal: true

# This is application controller
class ApplicationController < ActionController::Base
  require 'securerandom'
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :initialize_session
  before_action :load_cart
  before_action :set_search

  private

  def initialize_session
    session[:cart] ||= []
  end

  def load_cart
    @cart = Product.find(session[:cart])
  end

  def set_search
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).order(:id).page params[:page]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :avatar) }
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_back(fallback_location: root_path)
  end
end
