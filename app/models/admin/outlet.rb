# frozen_string_literal: true

# Outlet
class Admin
  # class Outlet from admin db
  class Outlet < Admin
    include ::StateMachines::Outlet
    belongs_to  :company,
                class_name: 'Admin::Company'

    belongs_to  :address,
                class_name: 'Admin::Address',
                dependent: :destroy

    has_many  :users,
              class_name: 'User',
              dependent: :destroy

    # after_create :generate_uuid

    accepts_nested_attributes_for :address,
                                  update_only: true,
                                  allow_destroy: true

    accepts_nested_attributes_for :users,
                                  allow_destroy: true
  end
end
