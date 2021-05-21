# frozen_string_literal: true

# Company
class Admin
  # class company from admin db
  class Company < Admin
    include ::StateMachines::Company

    belongs_to  :business_type,
                class_name: 'Admin::BusinessType'

    has_one :users,
            class_name: 'User',
            dependent: :destroy

    has_one :company_detail,
            class_name: 'Admin::CompanyDetail',
            dependent: :destroy

    has_many  :outlets,
              class_name: 'Admin::Outlet',
              dependent: :destroy

    # after_create :generate_registration_id
    after_create :set_company_detail

    accepts_nested_attributes_for :company_detail,
                                  update_only: true,
                                  allow_destroy: true

    def generate_registration_id
      update_column(:registration_id, set_registration_id)
    end

    def company
      self
    end

    def set_registration_id
      @registration_id = rand(100_000..1_000_000).to_s
      return @registration_id unless register_id.present?

      set_registration_id
    end

    def register_id
      Admin::Company.where(registration_id: @registration_id)
    end

    def set_company_detail
      address = Admin::Address.create(address1: 'default')
      Admin::CompanyDetail.create(company_id: company.id, address_id: address.id)
    end
  end
end
