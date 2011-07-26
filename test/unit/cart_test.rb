require 'test_helper'

class CartTest < ActiveSupport::TestCase

  def new_cart_with_one_product(product_name)
    cart = Cart.new
    cart.add_product(products(product_name).id)
    cart
  end
  
  test 'cart should create a new line item when adding a new product' do
    cart = new_cart_with_one_product(:one)
    assert_equal 1, cart.line_items.count
    # Add a new product
    cart.add_product(products(:ruby).id)
    assert_equal 2, cart.line_items.count
  end

end
