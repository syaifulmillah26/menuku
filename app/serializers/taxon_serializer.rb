# frozen_string_literal: true

# TaxonSerializer
class TaxonSerializer < ActiveModel::Serializer
  attributes :id, :ancestry, :taxonomy_id, :name, :permalink
end
