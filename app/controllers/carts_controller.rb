class CartsController < ApplicationController
  before_action :load_cart, only: [:index] 

  def index

  end

end
