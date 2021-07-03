# frozen_string_literal: true

# UserDetail
class UserDetail < ApplicationRecord
  belongs_to  :user,
              class_name: 'User',
              touch: true

  belongs_to  :address,
              class_name: 'Admin::Address',
              dependent: :destroy,
              optional: true

  accepts_nested_attributes_for :address,
                                update_only: true,
                                allow_destroy: true
end
