# frozen_string_literal: true

# Province
class Admin
  # class Province from admin db
  class Province < Admin
    has_many  :cities,
              class_name: 'Admin:City'
  end
end
