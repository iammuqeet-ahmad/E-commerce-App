# frozen_string_literal: true

require 'rails_helper'

# images handling remaaining
describe ProductsController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  before(:each) do
    sign_in(user)
  end
  describe 'Get #index' do
    it 'returns all the products excepts users products' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns all the products avaible on store' do
      sign_out(user)
      get :index
      expect(response).to have_http_status(:ok)
    end

    describe 'Get #my_products' do
      it 'returns all the products of the user' do
        get :my_products
        expect(response).to have_http_status(:ok)
      end

      it 'Unsuccessful' do
        sign_out(user)
        get :my_products
        expect(flash[:alert]).to eq('You must login first')
      end
    end

    it 'renders index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'Get #new' do
    it 'instantiate instance variable' do
      get :new
      expect(response).to have_http_status(:ok)
    end

    it 'renders new template' do
      get :new
      expect(response).to render_template :new
    end

    it 'new instance variable will not be initialized' do
      sign_out(user)
      get :new
      expect(flash[:alert]).to eq('Pease login first to add Product')
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'Post #create' do
    it 'create product successfully' do
      post :create,
           params: { product: { name: product.name, description: product.description, price: product.price,
                                quantity: product.quantity, serialNo: product.serialNo } }
      expect(flash[:success]).to eq('Successfully Added product.')
    end

    it 'product creation failed' do
      post :create,
           params: { product: { name: '', description: product.description, price: product.price, quantity: product.quantity,
                                serialNo: product.serialNo } }
      expect(response).to render_template :new
    end
  end

  describe 'Get #show' do
    it 'Shows the details of the product' do
      get :show, params: { id: product.id }
      expect(response).to have_http_status(:ok)
    end

    it 'Shows the product details fails' do
      get :show, params: { id: -1 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'Get #edit' do
    it 'render the edit form successfully' do
      sign_out(user)
      sign_in(product.user)
      get :edit, params: { id: product.id }
      expect(response).to render_template :edit
    end

    it 'successfully complete the http request status :ok' do
      sign_out(user)
      sign_in(product.user)
      get :edit, params: { id: product.id }
      expect(response).to have_http_status(:ok)
    end

    it 'edition of the product unsuccessful' do
      sign_in(user)
      get :edit, params: { id: product.id }
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end

  describe 'Put #update' do
    it 'successfully update the product' do
      params = { name: 'pants', description: 'These are cotton pants', price: 5000 }
      sign_out(user)
      sign_in(product.user)
      put :update, params: { id: product.id, product: params }
      expect(flash[:success]).to eq('Successfully Updated product.')
    end

    it 'updation of Product unsuccessful' do
      params = { name: 'pants', description: 'These are cotton pants', price: 5000 }
      sign_in(user)
      put :update, params: { id: product.id, product: params }
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end

    it 'updation of Product unsuccessful and render edit' do
      params = { name: '', description: 'These are cotton pants', price: 5000 }
      sign_out(user)
      sign_in(product.user)
      put :update, params: { id: product.id, product: params }
      expect(response).to render_template :edit
    end
  end

  describe 'delete #destroy' do
    it 'successfully deletes the product' do
      sign_out(user)
      sign_in(product.user)
      delete :destroy, params: { id: product.id }
      expect(flash[:success]).to eq('Successfully Deleted product.')
    end

    it 'successfully deletes the product and redirect' do
      sign_out(user)
      sign_in(product.user)
      delete :destroy, params: { id: product.id }
      expect(response).to redirect_to products_path
    end

    it 'deletion of product Unsuccessful because of wrong id' do
      delete :destroy, params: { id: -1 }
      expect(response).to have_http_status(:not_found)
    end

    it 'deletion of product Unsuccessful because of unauthorized user' do
      sign_in(user)
      delete :destroy, params: { id: product.id }
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end

  describe 'update quantity of product' do
    it 'successfuly updates the quantity of the product' do
      patch :update_quantity, params: { id: product.id, quantity: product.quantity }
      expect(flash[:notice]).to eq('Successfully updated')
    end

    it 'successfuly updates the quantity of the product and renders back to cart' do
      patch :update_quantity, params: { id: product.id, quantity: product.quantity }
      expect(response).to redirect_to carts_path
    end

    it 'quantity updation unsuccessful' do
      patch :update_quantity, params: { id: product.id, quantity: -1 }
      expect(flash[:alert]).to eq('Quantity updation unsuccessful')
    end
  end
end
