module CartsHelper
  def total_amount(cart)
    sum=0
    cart.each do |product|
      sum=sum+product.price
    end 
    sum
  end
end
