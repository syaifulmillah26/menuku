# frozen_string_literal: true

# City
class Admin
  # class City from admin db
  class City < Admin
    belongs_to  :province,
                class_name: 'Admin::Province'

    has_many  :subdistrict,
              class_name: 'Admin::Subdistrict'
  end
end
