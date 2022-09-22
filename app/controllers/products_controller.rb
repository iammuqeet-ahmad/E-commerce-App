# frozen_string_literal: true

# This is product controller
class ProductsController < ApplicationController
  before_action :remove_product, only: %i[remove_from_cart remove_in_cart]
  before_action :set_product, only: %i[destroy update show edit]

  def index
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).order(:id).page params[:page]
    # @products= Product.order(:id).page params[:page]
  end

  def new
    if user_signed_in?
      @product = Product.new
    else
      flash[:alert] = 'Pease login first to add Product'
      redirect_to new_user_session_path
    end
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    @product.serialNo = SecureRandom.alphanumeric(5)
    @product.quantity = 1
    if @product.save
      flash[:success] = 'Successfully Added product.'
      redirect_to product_path(@product)
    else
      render 'new', alert: 'Failed to add product'
    end
  end

  def show
    @photos = @product.photos.page(params[:page]).per(1)
    @comment = Comment.new
    @comments = @product.comments.order('created_at DESC')
  end

  def edit
    authorize @product
  end

  def update
    authorize @product
    if @product.update(product_params)
      flash[:success] = 'Successfully Updated product.'
      redirect_to product_path(@product)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @product
    if @product.destroy ### if else
      flash[:success] = 'Successfully Deleted product.'
      redirect_to products_path
    else
      flash[:alert] = 'Error deleting product.'
    end
  end

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

  def update_quantity
    product = Product.find(params[:id])
    product.quantity = params[:product][:quantity]
    product.save
    redirect_to carts_path, notice: 'Successfully updated'
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :user_id, photos: [])
  end

  def remove_product
    id = params[:id].to_i
    session[:cart].delete(id)
    @product = Product.find_by(id: id)
    @product.quantity = 1
    @product.save
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
