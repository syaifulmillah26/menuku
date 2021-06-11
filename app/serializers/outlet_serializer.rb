# frozen_string_literal: true

# OutletSerializer
class OutletSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :status, :address
end
