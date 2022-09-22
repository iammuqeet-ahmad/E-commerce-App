module CartsHelper
  def total_amount(cart)
    sum=0
    price=0
    cart.each do |product|
      price=product.quantity*product.price
      sum=sum+price
    end 
    sum
  end

  def cart_count(cart)
    if cart.count!=0
      return true
    else
      return false
    end
  end 
end
