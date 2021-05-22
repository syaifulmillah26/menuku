class TaxonomySerializer < ActiveModel::Serializer
  attributes :id, :outlet_id, :name, :root, :taxons

  def root
    object.root
  end
end
