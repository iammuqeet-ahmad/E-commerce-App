# frozen_string_literal: true

# This is messages controller
class MessagesController < ApplicationController
  before_action :clear_quantity, only: [:success_message]

  def success_message
    session[:cart] = []
    flash[:notice] = 'Order successfull'
    redirect_to root_path
  end

  def cancle_message
    flash[:alert] = 'Order unsuccessful'
    redirect_to root_path
  end

  private

  def clear_quantity
    @cart.each do |cart|
      cart.quantity = 1
      cart.save
    end
    $val = 0
  end
end
