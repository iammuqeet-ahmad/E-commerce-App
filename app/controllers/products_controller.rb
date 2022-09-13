class ProductsController < ApplicationController
  def index
    @products = Product.order(:id).page params[:page]
  end
  def new
    if user_signed_in?
      @product = Product.new
    else
      flash[:alert] = "Pease login first to add Product"
      redirect_to new_user_session_path
    end
  end
  def create
    @product = Product.new(product_params)
    @product.user_id= current_user.id
    @product.serialNo= "123fd"
    if @product.save  
      flash[:notice] = "Successfully Added product."
      redirect_to product_path(@product)
    else   
      render 'new', alert: "Failed to add product"
    end
  end
  def show
    @product= Product.find(params[:id])
    @comment = Comment.new
    @comments = @product.comments.order("created_at DESC")
  end

  private
  def product_params
    params.require(:product).permit(:name,:description,:price, :user_id, :photos => [])
  end
end
