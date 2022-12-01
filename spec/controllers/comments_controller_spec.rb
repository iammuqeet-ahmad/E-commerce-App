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
    let(:prev_comment_count) {Comment.count}
    let(:params) do
      {
        content:'This is awesome product'
      }
    end

    context 'Successfully creating the comment' do

      it 'should successful create the comment checking through(http status,flash,count of comment)' do
        post :create, xhr: true, params: { product_id: product.id, comment: params }
        expect(response).to have_http_status(:ok)
        expect(flash[:success]).to eq(I18n.t(:comment_created_successfully))
        expect(Comment.all.count).to eq(prev_comment_count )
      end

    end

    context 'Comment creation unsuccessful' do

      it 'should not create comment checking through(flash,comment count)' do
        params[:content] = ''
        post :create, xhr: true, params: { product_id: product.id, comment: params }
        expect(flash[:error]).to eq(I18n.t(:comment_creation_unsuccessful))
        expect(prev_comment_count).to eq(Comment.count)
      end

    end
  end

  describe 'Get #edit' do
    context 'When user is signed in edit comment successfully' do

      it 'should successfully render the edit form checking through(render template,http status)' do
        get :edit, params: { product_id: product.id, id: comment.id }
        expect(response).to render_template :edit
        expect(response).to have_http_status(:ok)
      end

    end

    context 'When user is signed out Edit unsuccessful' do
      
      it 'should not render edit form checking through(flash)' do
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

    context 'Comment updation Successfull' do
      
      it 'should successfully update the comment' do
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

      it 'should not update the comment checking through(flash)' do
        sign_in(user2)
        put :update, params: @params
        expect(flash[:alert]).to eq(I18n.t(:not_authorized))
      end

      it 'should not update the comment checking through(render template)' do
        put :update, params: @params
        expect(response).to render_template :edit
      end

    end
  end

  describe 'Delete #destroy' do

    let(:prev_comment_count) {Comment.count}
    let(:params) do
      {
        product_id: product.id,
        id: comment.id
      }
    end

    context 'Successfully deleting the comment' do

      it 'should successfully deletes the comment checking through (flash,comment count)' do
        delete :destroy, xhr: true, params: params
        expect(flash[:success]).to eq(I18n.t(:comment_deleted_successfully))
        expect(Comment.count).to eq(prev_comment_count)
      end

    end

    context 'Deletion of Comment Unsuccessful' do
      
      it 'should not deletes the comment checking through(flash)' do
        sign_in(user2)
        delete :destroy, params: params
        expect(flash[:alert]).to eq(I18n.t(:not_authorized))
      end

    end
  end

end
