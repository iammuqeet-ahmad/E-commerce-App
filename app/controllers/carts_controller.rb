# frozen_string_literal: true

# This is cart controller
class CartsController < ApplicationController
  before_action :remove_product, only: %i[remove_from_cart remove_in_cart]

  def index; end
  $val = 0
  def add_to_cart
    id = params[:id].to_i
    session[:cart] << id unless session[:cart].include?(id)
    redirect_to products_path, notice: 'Successfully added to cart.'
  end

  def remove_from_cart
    redirect_to products_path, notice: 'Successfully removed from cart.'
  end

  def remove_in_cart
    redirect_to carts_path, notice: 'Successfully removed from cart.'
  end

  private

  def remove_product
    id = params[:id].to_i
    session[:cart].delete(id)
    @product = Product.find_by(id: id)
    @product.quantity = 1
    @product.save
  end
end
