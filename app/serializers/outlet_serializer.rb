# frozen_string_literal: true

# OutletSerializer
class OutletSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :status, :address_attributes

  def address_attributes
    object.address.as_json.merge(
      province: object&.address&.province,
      city: object&.address&.city,
      subdistrict: object&.address&.subdistrict
    )
  end
end
