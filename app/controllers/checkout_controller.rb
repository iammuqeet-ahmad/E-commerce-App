# frozen_string_literal: true

# This is checkout controller
class CheckoutController < ApplicationController
  def create
    @session = Stripe::Checkout::Session.create({
                                                  payment_method_types: ['card'],
                                                  line_items: [{
                                                    price_data: { currency: 'usd',
                                                                  product_data: { name: 'Total Amount' },
                                                                  unit_amount: (total_amount(@cart).to_i * 100) },
                                                    quantity: 1
                                                  }],
                                                  mode: 'payment',
                                                  success_url: success_msg_url,
                                                  cancel_url: carts_url
                                                })
    respond_to do |format|
      format.js
    end
  end

  private

  def destroy_session
    session[:cart]&.delete(params[:id])
  end

  def total_amount(cart)
    sum = 0
    price = 0
    cart.each do |product|
      price = product.quantity * product.price
      sum += price
    end
    sum
  end
end
