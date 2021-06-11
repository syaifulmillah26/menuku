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

  after_create  :update_order
  after_update  :update_order
  after_destroy :update_order

  private

  def order
    Order.find(object&.order_id)
  end

  def update_order
    order.update_attribute(:item_count, items_quantity)
    order.update_attribute(:item_total, items_quantity * object&.product&.price&.amount)
  end

  def items_quantity
    order.items.map(&:quantity).inject(0) { |sum, x| sum + x }
  end
end
