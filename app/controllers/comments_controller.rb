class CommentsController < ApplicationController
  before_action :set_product
  before_action :authenticate_user!

  def create
    if @product.user_id!=current_user.id
      @comment= @product.comments.new(comment_params)
      @comment.user= current_user
      @comment.save
    else
      redirect_back(fallback_location:product_path(:product_id))
    end
  end

  def show; 
  end

  def update
    @comment=Comment.find(params[:id])
    if @comment.update(comment_params)
      flash[:notice] = "Comment updated successfully."
      redirect_to product_comments_path(:product_id)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment_id=@comment.id
    @comment.destroy
    flash[:notice] = "Comment deleted successfully."
  end
  private
  def comment_params 
    params.require(:comment).permit(:content,:product_id)
  end 

  def set_product
    @product = Product.find(params[:product_id]) 
  end

end
