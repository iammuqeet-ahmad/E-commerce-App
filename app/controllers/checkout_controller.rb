class CheckoutController < ApplicationController
  # after_action :destroy_session, only: [:create]
  def create
    total_amount = params[:amount]
    @session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: { currency: 'usd',product_data: { name: 'Total Amount'}, unit_amount: (total_amount.to_i * 100)},quantity: 1}],
      mode: 'payment',
      success_url: root_url,
      cancel_url: carts_url,
    }) 
    respond_to do |format|
      format.js
    end
  end

  private
  def destroy_session
    session[:cart].delete(params[:id]) if session[:cart]
  end
end