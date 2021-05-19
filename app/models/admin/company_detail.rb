# frozen_string_literal: true

# CompanyDetail
class Admin
  # class company from admin db
  class CompanyDetail < Admin
    belongs_to  :company,
                class_name: 'Admin::Company',
                touch: true,
                optional: true

    belongs_to  :address,
                class_name: 'Admin::Address',
                dependent: :destroy

    accepts_nested_attributes_for :address,
                                  update_only: true,
                                  allow_destroy: true
  end
end
