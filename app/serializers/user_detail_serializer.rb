# frozen_string_literal: true

# UserSerializer
class UserDetailSerializer < ActiveModel::Serializer
  attributes :id, :fullname, :address

  def address
    return if object.address.blank?

    object.address.as_json.merge(
      province: object&.address&.province,
      city: object&.address&.city,
      subdistrict: object&.address&.subdistrict
    )
  end
end
