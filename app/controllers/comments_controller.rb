# frozen_string_literal: true

# This is comment controller
class CommentsController < ApplicationController
  before_action :set_product
  before_action :set_comment, only: %i[destroy update]

  def create
    authorize @product, policy_class: CommentPolicy
    @comment = @product.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def update
    if @comment.update(comment_params)
      flash[:success] = 'Comment updated successfully.'
      redirect_to product_comments_path(:product_id)
    end
  end

  def destroy
    authorize @comment
    if @comment.destroy
      flash[:success] = 'Comment deleted successfully.'
    else
      flash[:alert] = 'Comment deletion unsuccessfully.'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :product_id)
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
