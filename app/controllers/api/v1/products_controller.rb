module Api
  module V1
    class ProductsController < ApplicationController

      def index
        render json: Product.all, message:"Listing all the products",each_serializer: ProductsSerializer
      end

      def show
        render json: Product.find(params[:id]),message:"Showing details of the product",serializer: ProductSerializer
      end

    end
  end
end
