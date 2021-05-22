# frozen_string_literal: true

# taxons
class Taxon < ApplicationRecord
  # attr_accessor :parent_id
  has_ancestry
  # acts_as_nested_set dependent: :destroy

  belongs_to  :taxonomy,
              class_name: 'Taxonomy',
              inverse_of: :taxons,
              optional: true

  has_many    :classifications,
              -> { order(:position) },
              dependent: :delete_all,
              inverse_of: :taxon

  has_many :products, through: :classifications

  before_create :set_permalink
  before_update :set_permalink
  # after_update :update_child_permalinks, if: :saved_change_to_permalink?

  validates :name, presence: true, uniqueness: true
  validates :meta_keywords, length: { maximum: 255 }
  validates :meta_description, length: { maximum: 255 }
  validates :meta_title, length: { maximum: 255 }

  after_create :set_position

  private

  def set_permalink
    permalink_tail = \
      parent_link.present? ? "#{parent_link}/#{dasherize}" : dasherize
    self.permalink = permalink_tail.downcase
  end

  def set_position
    position = self&.parent&.children&.maximum(:position).to_i + 1
    return update_column(:position, position) unless self&.parent.blank?
  end

  def parent_link
    self&.parent&.permalink
  end

  def dasherize
    name.gsub(' ', '-')
  end
end
