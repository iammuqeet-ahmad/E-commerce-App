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
      flash[:success] = I18n.t(:comment_created_successfully)
    else
      flash[:error] = I18n.t(:comment_creation_unsuccessful)
    end
  end

  def edit
    authorize @comment
  end

  def update
    authorize @comment
    if @comment.update(comment_params)
      flash[:success] = I18n.t(:comment_updated_successfully)
      redirect_to product_path(@product)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @comment
    @comment.destroy
    flash[:success] = I18n.t(:comment_deleted_successfully)
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
