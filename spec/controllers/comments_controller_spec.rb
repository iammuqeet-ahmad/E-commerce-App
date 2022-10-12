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
    it 'successful creation of comment checking status' do
      post :create, xhr: true, params: { product_id: product.id, comment: { content: comment.content } }
      expect(response).to have_http_status(:ok)
    end

    it 'successful creation of comment checking flash message' do
      post :create, xhr: true, params: { product_id: product.id, comment: { content: comment.content } }
      expect(flash[:success]).to eq('successfully created comment.')
    end

    it 'comment creation unsuccessful' do
      post :create, xhr: true, params: { product_id: product.id, comment: { content: '' } }
      expect(flash[:error]).to eq('An error has occurred while creating comment.')
    end
  end

  describe 'Get #edit' do
    it 'render the edit form successfully' do
      get :edit, params: { product_id: product.id, id: comment.id }
      expect(response).to render_template :edit
    end
  end

  describe 'Put #update' do
    it 'successfully update the comment' do
      put :update, xhr: true,
                   params: { product_id: product.id, id: comment.id, comment: { content: 'I dont like this product' } }
      expect(flash[:success]).to eq('Successfully Updated comment.')
    end

    it 'updation of comment unsuccessful' do
      sign_in(user2)
      put :update, params: { product_id: product.id, id: comment.id, comment: { content: '' } }
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end

    it 'updation of comment unsuccessful and render edit' do
      params = { name: '', description: 'These are cotton pants', price: 5000 }
      put :update, params: { product_id: product.id, id: comment.id, comment: { content: '' } }
      expect(response).to render_template :edit
    end
  end

  describe 'Delete #destroy' do
    it 'successfully deletes the comment' do
      delete :destroy, xhr: true, params: { product_id: product.id, id: comment.id }
      expect(flash[:success]).to eq('Comment deleted successfully.')
    end

    it 'Deletion of comment unsuccessful' do
      sign_in(user2)
      delete :destroy, params: { product_id: product.id, id: comment.id }
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end
end
