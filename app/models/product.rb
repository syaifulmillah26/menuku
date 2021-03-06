# frozen_string_literal: true

# Product
class Product < ApplicationRecord
  include ApplicationHelper

  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to  :outlet,
              class_name: 'Admin::Outlet',
              optional: true

  has_one_attached :image, dependent: :destroy

  has_one :price, dependent: :destroy, inverse_of: :product

  has_many :classifications, dependent: :delete_all, inverse_of: :product
  has_many :taxons, through: :classifications, before_remove: :remove_taxon

  validates   :outlet_id, presence: true
  validates   :name, presence: true
  validates_uniqueness_of :name, scope: :outlet_id

  after_create :set_slug

  accepts_nested_attributes_for :price

  private

  def remove_taxon(taxon)
    removed_classifications = classifications.where(taxon: taxon)
    removed_classifications.each(&:remove_from_list)
  end
end
