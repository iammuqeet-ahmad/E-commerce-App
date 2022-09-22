# frozen_string_literal: true

# This is product helper
module ProductsHelper
  def product_count
    Product.count.zero?
  end
end
