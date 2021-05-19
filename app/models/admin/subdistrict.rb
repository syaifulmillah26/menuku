# frozen_string_literal: true

# Subdistrict
class Admin
  # class Subdistrict from admin db
  class Subdistrict < Admin
    belongs_to  :province,
                class_name: 'Admin::Province'
    belongs_to  :city,
                class_name: 'Admin::City'
  end
end
