# frozen_string_literal: true

# taxonomies
class Taxonomy < ApplicationRecord
  include ApplicationHelper
  # acts_as_list

  has_many    :taxons,
              inverse_of: :taxonomy

  has_one     :root,
              -> { where ancestry: nil },
              class_name: 'Taxon',
              dependent: :destroy

  validates_uniqueness_of :name, scope: :outlet_id
  validates :outlet_id, presence: true

  after_save :set_name
  after_create :set_position

  default_scope -> { order(position: :asc) }

  private

  def set_name
    if root
      root.update_columns(
        name: name,
        updated_at: Time.current
      )
    else
      object.root = Taxon.create!(taxonomy_id: id, name: name, outlet_id: outlet_id)
    end
  end

  def set_position
    update_column(:position, Taxonomy.maximum(:position).to_i)
  end
end
