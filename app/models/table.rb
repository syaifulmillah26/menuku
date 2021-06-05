# frozen_string_literal: true

# Table
class Table < ApplicationRecord
  include StateMachines::Table
  belongs_to  :outlet,
              class_name: 'Admin::Outlet',
              foreign_key: :outlet_id,
              primary_key: :uuid,
              optional: true

  scope :availables, -> { where(status: 'available') }
  scope :booked, -> { where(status: 'booked') }

  has_one     :active_order,
              -> { where status: %w[draft confirmed] },
              class_name: 'Order'

  private

  def set_guest_access
    update_column(:guest_access, set_number)
  end

  def set_number
    number = rand(1_000_000)
    number_exist = Table.where(guest_access: number)&.first

    return set_number if number_exist

    number
  end

  def remove_guest_access
    update_column(:guest_access, nil)
  end
end
