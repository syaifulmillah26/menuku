# frozen_string_literal: true

# Product
class Product < ApplicationRecord
  belongs_to  :outlet,
              class_name: 'Admin::outlet',
              dependent: :destroy,
              inverse_of: :product
end
