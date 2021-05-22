# frozen_string_literal: true

# Outlet
class Admin
  # class Outlet from admin db
  class Outlet < Admin
    include ::StateMachines::Outlet
    include ApplicationHelper
    include UuidHelper

    extend FriendlyId
    friendly_id :name, use: :slugged

    belongs_to  :company,
                class_name: 'Admin::Company',
                foreign_key: :company_id,
                primary_key: :uuid,
                optional: true

    belongs_to  :address,
                class_name: 'Admin::Address',
                dependent: :destroy,
                optional: true

    has_one     :admin_outlet,
                lambda {
                  joins(:roles)
                    .where(roles: { name: :admin })
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

    has_many    :products,
                class_name: 'Product',
                foreign_key: :outlet_id,
                primary_key: :uuid,
                inverse_of: :outlet

    validates   :name, presence: true, uniqueness: true

    after_create :set_slug

    accepts_nested_attributes_for :address,
                                  update_only: true,
                                  allow_destroy: true

    accepts_nested_attributes_for :admin_outlet,
                                  allow_destroy: true

    private

    def outlet
      self
    end

    def check_uuid
      Admin::Outlet.where(uuid: @uuid)
    end
  end
end
