# frozen_string_literal: true

# Order
class Order < ApplicationRecord
  include StateMachines::Order
  include ApplicationHelper

  belongs_to  :outlet,
              class_name: 'Admin::Outlet',
              foreign_key: :outlet_id,
              primary_key: :uuid,
              optional: true

  belongs_to  :table,
              class_name: 'Table',
              optional: true

  has_one     :payment,
              class_name: 'Payment'

  has_many    :items,
              class_name: 'LineItem',
              dependent: :delete_all,
              inverse_of: :order

  has_many    :cancel_items,
              -> { where(is_cancel: true) },
              through: :items

  after_create :generate_order_number

  after_update :count_total

  validate :ensure_table_is_available, on: :create

  def tax_and_service_included
    item_total + (
      item_total * tax_and_service / 100
    )
  end

  private

  def ensure_table_is_available
    table = Table.find_by(
      id: table_id, outlet_id: outlet_id
    )
    return errors.add(:table_id, 'does not exist') unless table
    return errors.add(:table_id, 'is booked') unless table&.available?

    table.booked!
  end

  def generate_order_number
    update_column(
      :number,
      check_generated_number('MN', generated_number, 'number', 1)
    )
  end

  def count_total
    update_column(:total, subtotal)
  end

  def subtotal
    item_total + (
      item_total * tax_and_service / 100 - promo_total
    )
  end
end
