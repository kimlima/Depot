class CombineItemsInCart < ActiveRecord::Migration
  def self.up
    # Replace multiple items for a single product in a cart with a single item
    Cart.all.each do |cart|
      # Count the number of each product in the cart
      sums = cart.line_items.group(:product_id).sum(:quantity)
      
      sums.each do |product_id, quantity|
        if quantity > 1
          # Remove individual items
          cart.line_items.where(:product_id => product_id).delete_all
          
          # Replace with a single item
          cart.line_items.create(:product_id => product_id, :quantity => quantity)
        end
      end
    end
  end

  def self.down
    # Split items with quantity > 1 into multiple lines
    LineItem.where("quantity>1").each do |lineitem|
      # Add individual items
      lineitem.quantity.times do
        LineItem.create :cart_id => lineitem.cart_id,
          :product_id => lineitem.product_id, :quantity => 1
      end
      
      # Destroy original item
      lineitem.destroy
    end
  end
end
