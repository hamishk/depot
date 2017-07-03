class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product)
    # Doesn't perform database operation
    current_item = line_items.find_by(product_id: product.id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product: product)
    end
    current_item
  end

  def remove_product!(product)
    # Does perform database operation
    current_item = line_items.find_by(product_id: product.id)
    if current_item.quantity > 1
      current_item.quantity -= 1
      current_item.save
    else 
      current_item.destroy
    end
  end

  def total_price
    line_items.sum(&:total_price)
  end
end
