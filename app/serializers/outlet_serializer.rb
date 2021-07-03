# frozen_string_literal: true

# OutletSerializer
class OutletSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :status, :address

  def address
    object.address.as_json.merge(
      province: object&.address&.province,
      city: object&.address&.city,
      subdistrict: object&.address&.subdistrict
    )
  end
end
