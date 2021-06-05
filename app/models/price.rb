# frozen_string_literal: true

# Price
class Price < ApplicationRecord
  belongs_to  :product,
              class_name: 'Product',
              inverse_of: :price,
              touch: true,
              optional: true
end
