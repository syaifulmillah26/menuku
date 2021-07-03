# frozen_string_literal: true

# Company
class Admin
  # class company from admin db
  class Company < Admin
    include ::StateMachines::Company
    include ApplicationHelper

    belongs_to  :business_type,
                class_name: 'Admin::BusinessType',
                optional: true

    has_one     :company_detail,
                class_name: 'Admin::CompanyDetail'

    has_many    :outlets,
                class_name: 'Admin::Outlet',
                dependent: :destroy

    has_many    :admin_outlets,
                lambda {
                  joins(:roles)
                    .where(roles: { name: :admin_outlet })
                },
                class_name: 'User',
                foreign_key: :company_id

    has_many    :employees,
                -> { where.not(outlet_id: nil) },
                class_name: 'User',
                foreign_key: :company_id

    validates :user_id, presence: true
    validates_uniqueness_of :user_id

    accepts_nested_attributes_for :company_detail,
                                  update_only: true,
                                  allow_destroy: true

    after_create :set_owner

    private

    def check_uuid
      Admin::Company.where(uuid: @uuid)
    end

    def set_owner
      user = ::User.find(object&.user_id)
      user.company_id = object&.uuid
      user.save
    end
  end
end
