class CombineItemsInCart < ActiveRecord::Migration[5.0]
  def up
    # take all products in a cart with multiple line items
    # and roll them up into a single line item

    # I completely yolo'd this and I was lucky it worked
    Cart.all.each do |cart|
      Product.all.each do |product|
        # search for all line items in a cart belonging to each product
        # side note: for many products this wouldnn't be super efficient
        line_items = LineItem.where(cart_id: cart.id, product_id: product.id)
        # get the earliest created line item for that product (will return nil if no line items)
        # (this first record becomes the master record)
        first = line_items.min_by(&:created_at)
        # add up all quantities for each line item to find grand total
        total_quantity = line_items.map(&:quantity).sum
        line_items.each do |li|
          if li.id == first.id
            # delete all line items except for the earliest created one (master record)
            li.quantity = total_quantity
            li.save
          else 
            li.destroy
          end
        end
      end
    end
  end
  def down
    # find all line items with a quantity greater than one then split them up
    Cart.all.each do |cart|
      cart.line_items.each do |li|
        while li.quantity > 1
          # create a new line item
          cart.line_items.build(product: li.product)
          # now reduce the count of the original line item
          li.quantity -= 1
          cart.save
          li.save
        end
      end
    end
  end
end
