module ProductsHelper
  
  def product_count()
    if Product.count==0
      return true
    else
      return false
    end
  end
end
