# frozen_string_literal: true

# Outlet
class Admin
  # class Outlet from admin db
  class Outlet < Admin
    include ::StateMachines::Outlet
    include ApplicationHelper

    extend FriendlyId
    friendly_id :name, use: :slugged

    belongs_to  :company,
                class_name: 'Admin::Company',
                optional: true

    belongs_to  :address,
                class_name: 'Admin::Address',
                dependent: :destroy,
                optional: true

    has_one     :admin_outlet,
                lambda {
                  joins(:roles)
                    .where(roles: { name: :admin_outlet })
                    .where.not(outlet_id: nil)
                },
                class_name: 'User',
                dependent: :destroy

    has_many    :employees,
                lambda {
                  joins(:roles)
                    .where.not(roles: { name: :admin })
                    .where.not(outlet_id: nil)
                },
                class_name: 'User',
                dependent: :destroy

    has_many    :tables,
                class_name: 'Table',
                dependent: :destroy,
                inverse_of: :outlet

    has_many    :orders,
                class_name: 'Order',
                dependent: :destroy,
                inverse_of: :outlet

    has_many    :products,
                class_name: 'Product',
                dependent: :destroy,
                inverse_of: :outlet

    validates   :name, presence: true, uniqueness: true

    after_create :set_slug

    accepts_nested_attributes_for :address,
                                  update_only: true,
                                  allow_destroy: true

    accepts_nested_attributes_for :admin_outlet,
                                  allow_destroy: true

    accepts_nested_attributes_for :tables,
                                  allow_destroy: true

    private
  end
end
