# frozen_string_literal: true

# This is cart controller
class CartsController < ApplicationController
  include Cartfunctions # including cartfunctions concern which have coupon_check function (to check the validity of the coupon code)
  before_action :load_cart, only: [:index]
  before_action :remove_product, only: %i[remove_from_cart remove_in_cart] # both actions redirects to different path so thats why made two actions

  $val = 0
  # loading cart on index page of cart which is stored in session
  def index; end

  def add_to_cart
    id = params[:id].to_i
    session[:cart] << id unless session[:cart].include?(id)
    redirect_to products_path, notice: 'Successfully added to cart.'
  end

  # removing form cart while on products page
  def remove_from_cart
    redirect_to products_path, notice: 'Successfully removed from cart.'
  end

  # removing form cart while on cart page
  def remove_in_cart
    redirect_to carts_path, notice: 'Successfully removed from cart.'
  end

  private # removing

  def remove_product
    id = params[:id].to_i
    session[:cart].delete(id)
    @product = Product.find_by(id: id)
    @product.quantity = 1
    @product.save
  end
end
