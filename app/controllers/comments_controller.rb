# frozen_string_literal: true

# This is comment controller
class CommentsController < ApplicationController
  before_action :set_product
  before_action :set_comment, only: %i[destroy update edit]

  def create
    authorize @product, policy_class: CommentPolicy
    @comment = @product.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:success] = 'successfully created comment.'
    else
      flash[:error] = 'An error has occurred while creating comment.'
    end
  end

  def edit
    authorize @comment
  end

  def update
    authorize @comment
    if @comment.update(comment_params)
      flash[:success] = 'Successfully Updated comment.'
      redirect_to product_path(@product)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @comment
    @comment.destroy
    flash[:success] = 'Comment deleted successfully.'
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
