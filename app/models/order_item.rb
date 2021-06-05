# frozen_string_literal: true

# OrderItem
class OrderItem < ApplicationRecord
  belongs_to  :product,
              class_name: 'Product',
              optional: true

  belongs_to  :order,
              class_name: 'Order',
              optional: true

  validates_uniqueness_of :product_id, scope: :order_id
end
