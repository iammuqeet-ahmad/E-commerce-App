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

      it 'should returns all the products excepts users products checking through (status,count,render)' do
        get :index
        products = assigns(:products)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template :index
        expect(products.count).to eq(Product.all.count - user.products.count)
      end

    end

    context 'When user is signed out' do

      it 'should return all the products avaible on store checking using count(products,http status)' do
        sign_out(user)
        get :index
        products = assigns(:products)
        expect(response).to have_http_status(:ok)
        expect(Product.all.count).to eq(products.count)
      end

    end
  end

  describe 'Get #my_products' do
    context 'When user is signed in' do

      it 'should returns all the products of the user' do
        get :my_products
        products = assigns(:products)
        expect(user.products.count).to eq(products.count)
        expect(response).to have_http_status(:ok)
      end

    end

    context 'When user is signed out' do

      it 'should not returns any product of user' do
        sign_out(user)
        get :my_products
        expect(flash[:alert]).to eq(I18n.t(:login_failed))
      end

    end
  end

  describe 'Get #new' do
    context 'When user is signed in' do

      it 'should instantiate instance variable of product checking through(http status,render template)' do
        get :new
        expect(response).to have_http_status(:ok)
        expect(response).to render_template :new
      end

    end

    context 'When user is signed out' do

      it 'should not initialize new instance variable checking through(flash,redirect path)' do
        sign_out(user)
        get :new
        expect(flash[:alert]).to eq(I18n.t(:login_failed))
        expect(response).to redirect_to new_user_session_path
      end

    end
  end

  describe 'Post #create' do
    let(:prev_product_count) {Product.count}

    context 'Successfully creating the product' do
      let(:params) do
        {
          product: 
          {
            name: "Nike Air Shoes",
            description: "Brand new shoes",
            price: 4000,
            serialNo: "123ab"
          }
        }
      end

      it 'should create product successfully and also check the count of the product' do
        post :create, params: params
        expect(flash[:success]).to eq(I18n.t(:product_successfully_created))
        expect(Product.all.count).to eq(prev_product_count)
      end

    end

    context 'Product creation Unsuccessful' do

      let(:params) do
        {
          product: 
          {
            name: "",
            description: "Brand new shoes",
            price: 4000
          }
        }
      end

      it 'should not create product checking through (render template,count)' do 
        post :create, params: params 
        expect(Product.all.count).to eq(prev_product_count)
        expect(response).to render_template :new
      end

    end
  end

  describe 'Get #show' do
    
    context 'Show the product' do

      it 'should show all the details of the product checking through (http status, product exists)' do
        get :show, params: { id: product.id }
        expect(response).to have_http_status(:ok)
        expect(assigns(:product)).to be_truthy
      end

    end

    context 'Show the product Fails' do

      it 'should not shows details of the product checking through (http status, product exists)' do
        get :show, params: { id: -1 }
        expect(response).to have_http_status(:not_found)
        expect(assigns(:product)).to be_falsey
      end

    end
  end

  describe 'Get #edit' do
    context 'When user is signed in edit successfully' do

      it 'should render the edit form successfully checking through(render template,http status)' do
        get :edit, params: { id: product.id }
        expect(response).to render_template :edit
        expect(response).to have_http_status(:ok)
      end

    end

    context 'When user is signed out edit unsuccessful' do

      it 'should not render edit form of the product checking through(flash)' do
        sign_in(user2)
        get :edit, params: { id: product.id }
        expect(flash[:alert]).to eq(I18n.t(:not_authorized))
      end

    end
  end

  describe 'Put #update' do

    let(:params) do
      {
        name: "pants",
        description: "These are cotton pants",
        price: 6000
      }
    end

    context 'Successfully updating the product' do

      it 'should successfully update the product checking through(flash,{price,quantity,description updation})' do
        put :update, params: {id: product.id, product: params }
        product_updation = assigns(:product)
        expect(flash[:success]).to eq(I18n.t(:product_successfully_updated))
        expect(product_updation.name).to eq(params[:name])
        expect(product_updation.description).to eq(params[:description])
        expect(product_updation.price).to eq(params[:price])
      end

    end

    context 'Updation of product Unsuccessful' do

      it 'should not update the Product checking through user not signed in' do
        sign_in(user2)
        put :update, params: { id: product.id,product: params }
        expect(flash[:alert]).to eq(I18n.t(:not_authorized))
      end

      it 'should not update the product checking through render template' do
        params[:name] = ''
        put :update, params: { id: product.id,product: params }
        expect(response).to render_template :edit
      end

    end
  end

  describe 'delete #destroy' do
    context 'Successfully deleting the product' do
      
      it 'should successfully deletes the product' do
        countProducts = Product.count
        delete :destroy, params: { id: product.id }
        expect(flash[:success]).to eq(I18n.t(:product_successfully_deleted))
        expect(response).to redirect_to products_path
        expect(Product.count).to eq(countProducts)
      end

    end

    context 'Deletion of the product Failed ' do
      
      it 'should not deletes the product because of wrong id' do
        delete :destroy, params: { id: -1 }
        expect(response).to have_http_status(:not_found)
      end

      it 'should not deletes the product because of unauthorized user' do
        sign_in(user2)
        delete :destroy, params: { id: product.id }
        expect(flash[:alert]).to eq(I18n.t(:not_authorized))
      end

    end
  end

  describe 'update quantity of product' do
    context 'Successfully updating the quantity of the product' do

      it 'should successfuly updates the quantity of the product checking through (flash,redirect path,quantity count increased)' do
        patch :update_quantity, params: { id: product.id, quantity: 7 }
        expect(flash[:notice]).to eq(I18n.t(:quantity_successfully_updated))
        expect(response).to redirect_to carts_path
        product2 = Product.find(product.id)
        expect(product2.quantity).to eq(7)
      end

    end

    context 'Updation of quanity of the product is Unsuccessful' do

      it 'should not update the quantity of the product checking through (flash,quantity count)' do
        patch :update_quantity, params: { id: product.id, quantity: -1 }
        expect(flash[:alert]).to eq(I18n.t(:quantity_updation_unsuccessfully))
        product2 = Product.find(product.id)
        expect(product2.quantity).to eq(1)
      end

    end
  end
end
