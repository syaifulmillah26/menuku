# frozen_string_literal: true

# CompanyDetail
class Admin
  # class company from admin db
  class CompanyDetail < Admin
    belongs_to  :company,
                class_name: 'Admin::Company',
                foreign_key: :company_id,
                primary_key: :uuid,
                touch: true

    belongs_to  :address,
                class_name: 'Admin::Address',
                dependent: :destroy,
                optional: true

    accepts_nested_attributes_for :address,
                                  update_only: true,
                                  allow_destroy: true

  end
end
