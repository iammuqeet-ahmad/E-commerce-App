# frozen_string_literal: true

# This is product controller
class ProductsController < ApplicationController
  require 'securerandom' # for randomly generating serialNo (alphanumeric)
  before_action :set_product, only: %i[destroy update show edit] # product finding function using params.

  def index
    # @q = Product.ransack(params[:q]) # q contains the seacrh params
    # # if search params exists then show that otherwise show all products
    # @products = @q.result(distinct: true).order(:id).page params[:page]


    if user_signed_in?
      @q = Product.where('user_id != ?', current_user.id).ransack(params[:q])
      @products = @q.result(distinct: true).order(:id).page params[:page]
    else
      @q = Product.ransack(params[:q]) # q contains the seacrh params
      # if search params exists then show that otherwise show all products
      @products = @q.result(distinct: true).order(:id).page params[:page]
    end
  end
  
  def my_products
    @q = current_user.products.ransack(params[:q])
    @products = @q.result(distinct: true).order(:id).page params[:page]
  end

  # user authentication for adding new product(user must be logged in)
  def new
    if user_signed_in?
      @product = Product.new
    else
      flash[:alert] = 'Pease login first to add Product'
      redirect_to new_user_session_path # otherwise rediresting to login page
    end
  end

  # creating new product
  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id # setting the current_user_id as the product_user_id
    @product.serialNo = SecureRandom.alphanumeric(5) # generating the random serial  numberNo for the product
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
    if @product.destroy
      flash[:success] = 'Successfully Deleted product.'
      redirect_to products_path
    else
      flash[:alert] = 'Error deleting product.'
    end
  end

  def update_quantity
    product = Product.find(params[:id])
    product.quantity = params[:quantity]
    product.save
    redirect_to carts_path, notice: 'Successfully updated'
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :user_id, photos: [])
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
