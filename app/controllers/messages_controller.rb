# frozen_string_literal: true

# This is messages controller
class MessagesController < ApplicationController
  before_action :clear_quantity, only: [:success_msg]
  def success_msg
    session[:cart] = []
    flash[:notice] = 'Order successfull'
    redirect_to root_path
  end

  def cancle_msg
    flash[:alert] = 'Order unsuccessful'
    redirect_to root_path
  end

  private

  def clear_quantity
    @cart.each do |cart|
      cart.quantity = 1
      cart.save
    end
  end
end
