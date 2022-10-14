# frozen_string_literal: true

require 'rails_helper'

describe ProductsController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product, user_id: user.id) }
  let(:user2) { create(:user) }

  before(:each) do
    sign_in(user)
  end

  describe 'Get #index' do
    context 'When user is signed in' do
      before { get :index }

      it 'Returns all the products excepts users products' do
        expect(response).to have_http_status(:ok)
      end

      it 'Renders index template' do
        expect(response).to render_template :index
      end

      it 'Returns all the products excepts users products checking using count(products)' do
        products = assigns(:products)
        expect(products.count).to eq(Product.all.count - user.products.count)
      end
    end

    context 'When user is signed out' do
      before do
        sign_out(user)
        get :index
      end

      it 'Returns all the products avaible on store' do
        expect(response).to have_http_status(:ok)
      end

      it 'Returns all the products avaible on store checking using count(products)' do
        products = assigns(:products)
        expect(Product.all.count).to eq(products.count)
      end
    end
  end

  describe 'Get #my_products' do
    context 'When user is signed in' do
      before do
        get :my_products
      end

      it 'Returns all the products of the user' do
        expect(response).to have_http_status(:ok)
      end

      it 'Returns all the products of the user checking using count(user.products)' do
        products = assigns(:products)
        expect(user.products.count).to eq(products.count)
      end
    end

    context 'When user is signed out' do
      it 'Unsuccessful to get any product of user' do
        sign_out(user)
        get :my_products
        expect(flash[:alert]).to eq(I18n.t(:login_failed))
      end
    end
  end

  describe 'Get #new' do
    context 'When user is signed in' do
      before do
        get :new
      end

      it 'Instantiate instance variable' do
        expect(response).to have_http_status(:ok)
      end

      it 'Renders new template' do
        expect(response).to render_template :new
      end
    end

    context 'When user is signed out' do
      it 'New instance variable will not be initialized' do
        sign_out(user)
        get :new
        expect(flash[:alert]).to eq(I18n.t(:login_failed))
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'Post #create' do
    context 'Product creation Successful' do
      it 'Create product successfully' do
        post :create,
             params: { product: product.attributes }
        expect(flash[:success]).to eq(I18n.t(:product_successfully_created))
      end
    end

    context 'Product creation Unsuccessful' do
      it 'Product creation failed because of name nill' do
        product.name = ''
        post :create,
             params: { product: product.attributes }
        expect(response).to render_template :new
      end

      it 'Product creation failed beacause of description nill' do
        product.description = ''
        post :create,
             params: { product: product.attributes }
        expect(response).to render_template :new
      end
    end
  end

  describe 'Get #show' do
    context 'Show the product' do
      before do
        get :show, params: { id: product.id }
      end

      it 'Shows the details of the product' do
        expect(response).to have_http_status(:ok)
      end

      it 'Shows the details of the product checking (if product exists returns true)' do
        expect(assigns(:product)).to be_truthy
      end
    end

    context 'Show the product Fails' do
      before do
        get :show, params: { id: -1 }
      end

      it 'Shows the product details fails' do
        expect(response).to have_http_status(:not_found)
      end

      it 'Shows the product fails (if product exists returns false)' do
        expect(assigns(:product)).to be_falsey
      end
    end
  end

  describe 'Get #edit' do
    context 'When user is signed in edit successfully' do
      before do
        get :edit, params: { id: product.id }
      end

      it 'Render the edit form successfully' do
        expect(response).to render_template :edit
      end

      it 'Successfully complete the http request status :ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'When user is signed out edit unsuccessful' do
      it 'Edition of the product unsuccessful' do
        sign_in(user2)
        get :edit, params: { id: product.id }
        expect(flash[:alert]).to eq(I18n.t(:not_authorized))
      end
    end
  end

  describe 'Put #update' do
    before do
      @params = { name: 'pants', description: 'These are cotton pants', price: 5000 }
    end
    context 'Successfully updating the product' do
      it 'Successfully update the product' do
        put :update, params: { id: product.id, product: @params }
        expect(flash[:success]).to eq(I18n.t(:product_successfully_updated))
      end

      it 'Successfully updating the product (checking updation)' do
        put :update, params: { id: product.id, product: @params }
        product_updation = assigns(:product)
        expect(product_updation.name).to eq(@params[:name])
        expect(product_updation.description).to eq(@params[:description])
        expect(product_updation.price).to eq(@params[:price])
      end
    end

    context 'Updation of product Unsuccessful' do
      it 'Updation of Product unsuccessful' do
        sign_in(user2)
        put :update, params: { id: product.id, product: @params }
        expect(flash[:alert]).to eq(I18n.t(:not_authorized))
      end

      it 'Updation of Product Unsuccessful and render edit' do
        @params[:name] = ''
        put :update, params: { id: product.id, product: @params }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'delete #destroy' do
    context 'Successfully deleting the product' do
      before do
        @countProducts = Product.all.count
        delete :destroy, params: { id: product.id }
      end
      it 'Successfully deletes the product' do
        expect(flash[:success]).to eq(I18n.t(:product_successfully_deleted))
      end

      it 'Successfully deletes the product and redirect' do
        expect(response).to redirect_to products_path
      end

      it 'Successfully deleting the product and checking count decrement' do
        expect(Product.all.count).to eq(@countProducts)
      end
    end

    context 'Deletion of the product Failed ' do
      it 'Deletion of product Unsuccessful because of wrong id' do
        delete :destroy, params: { id: -1 }
        expect(response).to have_http_status(:not_found)
      end

      it 'Deletion of product Unsuccessful because of unauthorized user' do
        sign_in(user2)
        delete :destroy, params: { id: product.id }
        expect(flash[:alert]).to eq(I18n.t(:not_authorized))
      end
    end
  end

  describe 'update quantity of product' do
    context 'Successfully updating the quantity of the product' do
      before do
        patch :update_quantity, params: { id: product.id, quantity: 7 }
      end

      it 'Successfuly updates the quantity of the product' do
        expect(flash[:notice]).to eq(I18n.t(:quantity_successfully_updated))
      end

      it 'Successfuly updates the quantity of the product and redirect back to cart' do
        expect(response).to redirect_to carts_path
      end

      it 'Successfuly updates the quantity of the product checking quanity count' do
        product2 = Product.find(product.id)
        expect(product2.quantity).to eq(7)
      end
    end

    context 'Updation of quanity of the product is Unsuccessful' do
      before do
        patch :update_quantity, params: { id: product.id, quantity: -1 }
      end
      it 'Quantity updation Unsuccessful' do
        expect(flash[:alert]).to eq(I18n.t(:quantity_updation_unsuccessfully))
      end

      it 'Quantity updation Unsuccessful checking quanity count' do
        product2 = Product.find(product.id)
        expect(product2.quantity).to eq(1)
      end
    end
  end
end
