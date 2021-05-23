# frozen_string_literal: true

# Company
class Admin
  # class company from admin db
  class Company < Admin
    include ::StateMachines::Company
    include UuidHelper

    belongs_to  :business_type,
                class_name: 'Admin::BusinessType',
                optional: true

    has_one     :company_detail,
                class_name: 'Admin::CompanyDetail',
                foreign_key: :company_id,
                primary_key: :uuid

    has_many    :outlets,
                class_name: 'Admin::Outlet',
                foreign_key: :company_id,
                primary_key: :uuid,
                dependent: :destroy

    has_many    :admin_outlets,
                lambda {
                  joins(:roles)
                    .where(roles: { name: :admin })
                    .where.not(outlet_id: nil)
                },
                class_name: 'User',
                foreign_key: :company_id

    has_many    :all_employees,
                -> { where.not(outlet_id: nil) },
                class_name: 'User',
                foreign_key: :company_id

    validates :user_id, presence: true
    validates_uniqueness_of :user_id

    accepts_nested_attributes_for :company_detail,
                                  update_only: true,
                                  allow_destroy: true

    private

    def company
      self
    end

    def check_uuid
      Admin::Company.where(uuid: @uuid)
    end
  end
end
