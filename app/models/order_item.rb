# frozen_string_literal: true

# OrderItem
class OrderItem < ApplicationRecord
  include ApplicationHelper
  belongs_to  :product,
              class_name: 'Product'

  belongs_to  :order,
              class_name: 'Order'

  validates :order_id, presence: true
  validates_uniqueness_of :product_id, scope: :order_id
end
