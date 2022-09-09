class ProductsController < ApplicationController
  before_action :create
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    if @product.save
      flash[:notice] = "Successfully created product."
      redirect_to @product_path(@product)
    else
      render :action => 'new'
    end
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def product_params
    params.require(:post).permit(:name,:description,:price,:picture)
  end
end
