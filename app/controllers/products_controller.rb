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
      flash[:alert] = I18n.t(:login_failed)
    end
  end

  def new
    if user_signed_in?
      @product = Product.new
    else
      flash[:alert] = I18n.t(:login_failed)
      redirect_to new_user_session_path
    end
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    if @product.save
      flash[:success] = I18n.t(:product_successfully_created)
      redirect_to product_path(@product)
    else
      render 'new', alert: I18n.t(:creation_of_product_unsuccessfully)
    end
  end

  def show
    @comment = Comment.new
    @comments = @product.comments.order('created_at DESC')
  end

  def edit
    authorize @product
  end

  def update
    authorize @product
    if @product.update(product_params)
      flash[:success] = I18n.t(:product_successfully_updated)
      redirect_to product_path(@product)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @product
    @product.destroy
    flash[:success] = I18n.t(:product_successfully_deleted)
    redirect_to products_path
  end

  def update_quantity
    product = Product.find(params[:id])
    if params[:quantity].to_i >= 1
      product.quantity = params[:quantity]
      product.save
      flash[:notice] = I18n.t(:quantity_successfully_updated)
    else
      flash[:alert] = I18n.t(:quantity_updation_unsuccessfully)
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
