# frozen_string_literal: true

# This is product controller
class ProductsController < ApplicationController
  before_action :set_product, only: %i[destroy update show edit]

  def index
    @q = if user_signed_in?
           Product.where('user_id != ?', current_user.id).ransack(params[:q])
         else
           Product.ransack(params[:q])
         end
    @products = @q.result(distinct: true).order(:id).page params[:page]
  end

  def my_products
    if user_signed_in?
      @q = current_user.products.ransack(params[:q])
      @products = @q.result(distinct: true).order(:id).page params[:page]
    else
      flash[:alert] = 'You must login first'
    end
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
    if @product.save
      flash[:success] = 'Successfully Added product.'
      redirect_to product_path(@product)
    else
      render 'new', alert: 'Failed to add product'
    end
  end

  def show
    @photos = @product.photos
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
    @product.destroy
    flash[:success] = 'Successfully Deleted product.'
    redirect_to products_path
  end

  def update_quantity
    product = Product.find(params[:id])
    if params[:quantity].to_i >= 1
      product.quantity = params[:quantity]
      product.save
      flash[:notice] = 'Successfully updated'
    else
      flash[:alert] = 'Quantity updation unsuccessful'
    end
    redirect_to carts_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :user_id, photos: [])
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
