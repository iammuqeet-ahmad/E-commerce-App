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
                                                  success_url: success_message_messages_url,
                                                  cancel_url: cancle_message_messages_url
                                                })
    respond_to do |format|
      format.js
    end
  end

  private

  def total_amount(cart)
    sum = 0
    price = 0
    cart.each do |product|
      price = product.quantity * product.price
      sum += price
    end
    discount = sum * $val
    sum - discount
  end
end
