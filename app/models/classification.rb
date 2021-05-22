# frozen_string_literal: true

# Classification
class Classification < ApplicationRecord
  self.table_name = 'products_taxons'
  acts_as_list scope: :taxon

  belongs_to  :product,
              class_name: 'Product',
              inverse_of: :classifications,
              touch: true,
              optional: true

  belongs_to  :taxon,
              class_name: 'Taxon',
              inverse_of: :classifications,
              touch: true, optional: true

  validates_uniqueness_of :taxon_id,
                          scope: :product_id,
                          message: :already_linked
end
