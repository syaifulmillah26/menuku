class TaxonSerializer < ActiveModel::Serializer
  attributes :id, :ancestry, :taxonomy_id, :name, :permalink
end
