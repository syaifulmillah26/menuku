# frozen_string_literal: true

# LineItem
class LineItem < ApplicationRecord
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

  def amount
    object&.product&.price&.amount
  end

  private

  def update_order
    order.update_attribute(:item_count, items_quantity)
    order.update_attribute(:item_total, items_quantity * amount)
    order.update_attribute(:total, subtotal)
  end

  def subtotal
    order.item_total + (
      order.item_total * order.tax_and_service / 100 - order.promo_total
    )
  end

  def items_quantity
    order.items.map(&:quantity).inject(0) { |sum, x| sum + x }
  end
end
