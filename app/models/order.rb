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

  has_many    :items,
              class_name: 'OrderItem',
              dependent: :delete_all,
              inverse_of: :order

  has_many    :cancel_items,
              -> { where(is_cancel: true) },
              through: :items

  accepts_nested_attributes_for :items

  after_create :generate_order_number

  private

  def generate_order_number
    update_column(:order_number, set_order_number)
    book_table
  end

  def set_order_number
    number = 'OR' + rand(1_000_000_000).to_s
    number_exist = Order.where(order_number: number)&.first

    return set_order_number if number_exist

    number
  end

  def book_table
    table = Table.find(object&.table_id)
    table.booked!
  end

  def free_table
    table = Table.find(object&.table_id)
    table.available!
  end
end
