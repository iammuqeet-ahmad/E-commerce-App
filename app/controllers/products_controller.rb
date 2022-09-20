class ProductsController < ApplicationController
  before_action :remove_product, only: [:remove_from_cart, :remove_in_cart] 
  before_action :set_product, only: [:destroy, :update, :show, :edit]
  def index
    @q= Product.ransack(params[:q])
    @products= @q.result(distinct: true).order(:id).page params[:page]
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
    @photos = @product.photos.page(params[:page]).per(1)
    @comment = Comment.new
    @comments = @product.comments.order("created_at DESC")
  end

  def edit
    if current_user.id != @product.user_id
      redirect_to root_path,:alert => "Failed to edit product."
    end
  end

  def update
    if current_user.id == @product.user_id
      if @product.update(product_params)
        flash[:notice] = "Successfully Updated product."
        redirect_to product_path(@product)
      else
        render 'edit'
      end
    else
      redirect_to root_path, :alert => "Error updating product."
    end
  end
  
  def destroy
    if current_user.id == @product.user_id
      if @product.destroy ### if else
        flash[:notice] = "Successfully Deleted product."
        redirect_to products_path
      else
        flash[:alert] = "Error deleting product."
      end
    else
      flash[:alert] = "You are not authorized to delete this product"
      redirect_to products_path
  end

  def search
    render json: {}
  end

  def add_to_cart
    id = params[:id].to_i
    session[:cart] << id unless session[:cart].include?(id)
    redirect_to products_path(@product), :notice => "Successfully added to cart."
  end

  def remove_from_cart
    redirect_to products_path, :notice => "Successfully removed from cart."
  end
  
  def remove_in_cart
    redirect_to carts_path,  :notice => "Successfully removed from cart."
  end

  private
  def product_params
    params.require(:product).permit(:name,:description,:price, :user_id, photos: [] )
  end

  def remove_product
    id = params[:id].to_i
    session[:cart].delete(id)
  end
  
  def set_product
    @product = Product.find(params[:id])
  end
    
end
