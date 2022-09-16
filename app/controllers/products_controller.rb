class ProductsController < ApplicationController
  before_action :remove_product, only: [:remove_from_cart, :remove_in_cart] 
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
    @product.serialNo= SecureRandom.alphanumeric(5)
    if @product.save  
      flash[:notice] = "Successfully Added product."      
      redirect_to product_path(@product)
    else   
      render 'new', alert: "Failed to add product"
    end
  end

  def show
    @product= Product.find(params[:id])
    @photos = @product.photos.page(params[:page]).per(1)
    @comment = Comment.new
    @comments = @product.comments.order("created_at DESC")
  end

  def edit
    @product= Product.find(params[:id])
  end

  def update
    @product= Product.find(params[:id])
    if @product.update(product_params)
      flash[:notice] = "Successfully Updated product."
      redirect_to product_path(@product)
    else
      render 'edit'
    end
  end
  
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    flash[:notice] = "Successfully Deleted product."
    redirect_to products_path
  end

  def search
    render json: {}
  end

  def add_to_cart
    id = params[:id].to_i
    session[:cart] << id unless session[:cart].include?(id)
    redirect_to products_path(@product)
  end

  def remove_from_cart
    redirect_to products_path
  end
  
  def remove_in_cart
    redirect_to carts_path
  end

  private
  def product_params
    params.require(:product).permit(:name,:description,:price, :user_id, photos: [] )
  end

  def remove_product
    id = params[:id].to_i
    session[:cart].delete(id)
  end
end
