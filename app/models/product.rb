# frozen_string_literal: true

# Product
class Product < ApplicationRecord
  include ApplicationHelper

  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to  :outlet,
              class_name: 'Admin::outlet',
              dependent: :destroy,
              foreign_key: :outlet_id,
              primary_key: :uuid,
              optional: true

  has_one_attached :image

  validates   :outlet_id, presence: true
  validates   :name, presence: true
  validates_uniqueness_of :name, scope: :outlet_id

  has_many :classifications, dependent: :delete_all, inverse_of: :product
  has_many :taxons, through: :classifications, before_remove: :remove_taxon

  after_create :set_slug

  private

  def remove_taxon(taxon)
    removed_classifications = classifications.where(taxon: taxon)
    removed_classifications.each(&:remove_from_list)
  end
end
