# frozen_string_literal: true

# TaxonomySerializer
class TaxonomySerializer < ActiveModel::Serializer
  attributes :id, :outlet_id, :name
end
