# frozen_string_literal: true

# This is cart controller
class CartsController < ApplicationController
  include Cartfunctions
  before_action :load_cart, only: [:index]
  $val = 0
  def index; end
end
