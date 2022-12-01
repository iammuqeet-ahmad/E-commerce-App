# frozen_string_literal: true

# This is cart helper
module CartsHelper
  def total_amount(cart)
    sum = 0
    price = 0
    cart.each do |product|
      price = product.quantity * product.price
      sum += price
    end
    sum
  end

  def cart_count(cart)
    if cart.count != 0
      true
    else
      $val = 0
      false
    end
  end
end
