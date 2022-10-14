# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:product) { create(:product, user_id: user2.id) }
  let(:comment) { create(:comment, user_id: user.id, product_id: product.id) }

  before(:each) do
    sign_in(user)
  end

  describe 'Post #create' do
    before do
      @prevCommentCount = Comment.count
    end
    context 'Successfully creating the comment' do
      before do
        post :create, xhr: true, params: { product_id: product.id, comment: { content: comment.content } }
      end

      it 'successful creation of comment checking status' do
        expect(response).to have_http_status(:ok)
      end

      it 'successful creation of comment checking flash message' do
        expect(flash[:success]).to eq(I18n.t(:comment_created_successfully))
      end

      it 'successful creation of comment checking comment count' do
        expect(Comment.all.count).to eq(@prevCommentCount + 2) #####
      end
    end

    context 'Comment creation unsuccessful' do
      before do
        post :create, xhr: true, params: { product_id: product.id, comment: { content: '' } }
      end
      it 'comment creation unsuccessful' do
        expect(flash[:error]).to eq(I18n.t(:comment_creation_unsuccessful))
      end
      it 'comment creation unsuccessful checking if comment count changed' do
        expect(@prevCommentCount).to eq(Comment.count)
      end
    end
  end

  describe 'Get #edit' do
    context 'When user is signed in edit comment successfully' do
      before do
        get :edit, params: { product_id: product.id, id: comment.id }
      end

      it 'render the edit form successfully' do
        expect(response).to render_template :edit
      end

      it 'Successfully complete the http request status :ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'When user is signed out Edit unsuccessful' do
      it 'Edition of the comment unsuccessful' do
        sign_in(user2)
        get :edit, params: { product_id: product.id, id: comment.id }
        expect(flash[:alert]).to eq(I18n.t(:not_authorized))
      end
    end
  end

  describe 'Put #update' do
    before do
      @params = { product_id: product.id, id: comment.id, comment: { content: 'I dont like this product' } }
    end
    context 'Comment updation Successful' do
      it 'successfully update the comment' do
        put :update, xhr: true, params: @params
        expect(flash[:success]).to eq(I18n.t(:comment_updated_successfully))
      end

      it 'Successfully updating the comment (checking updation)' do
        put :update, xhr: true, params: @params
        comment_updation = Comment.find(comment.id)
        expect(comment_updation.content).to eq(@params[:comment][:content])
      end
    end

    context 'Updation of Comment unsuccessful' do
      before do
        @params[:comment][:content] = ''
      end
      it 'updation of comment unsuccessful' do
        sign_in(user2)
        put :update, params: @params
        expect(flash[:alert]).to eq(I18n.t(:not_authorized))
      end

      it 'updation of comment unsuccessful and render edit' do
        put :update, params: @params
        expect(response).to render_template :edit
      end
    end
  end

  describe 'Delete #destroy' do
    before do
      @prev_comment_count = Comment.count
      @params = { product_id: product.id, id: comment.id }
    end
    context 'Successfully deleting the comment' do
      before do
        delete :destroy, xhr: true, params: @params
      end
      it 'successfully deletes the comment' do
        expect(flash[:success]).to eq(I18n.t(:comment_deleted_successfully))
      end

      it 'successfully deletes the comment and check comment count' do
        expect(Comment.count).to eq(@prev_comment_count)##
      end
    end

    context 'Delettion of Comment Unsuccessful' do
      it 'Deletion of comment unsuccessful' do
        sign_in(user2)
        delete :destroy, params: @params
        expect(flash[:alert]).to eq(I18n.t(:not_authorized))
      end

      it 'Deletion of comment unsuccessful checking through count' do
        @prev_comment_count2 = Comment.count
        sign_in(user2)
        delete :destroy, params: @params
        expect(Comment.count).to eq(@prev_comment_count2)
      end
    end
  end
end
