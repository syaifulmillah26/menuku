# frozen_string_literal: true

# Table
class Table < ApplicationRecord
  include StateMachines::Table
  belongs_to  :outlet,
              class_name: 'Admin::Outlet'

  scope :availables, -> { where(status: 'available') }
  scope :booked, -> { where(status: 'booked') }

  has_one     :active_order,
              -> { where status: %w[draft confirmed] },
              class_name: 'Order'
end
