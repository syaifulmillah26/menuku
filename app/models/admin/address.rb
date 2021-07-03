# frozen_string_literal: true

# Address
class Admin
  # class company from admin db
  class Address < Admin
    belongs_to :province, class_name: 'Admin::Province', optional: true
    belongs_to :city, class_name: 'Admin::City', optional: true
    belongs_to :subdistrict, class_name: 'Admin::Subdistrict', optional: true
  end
end
