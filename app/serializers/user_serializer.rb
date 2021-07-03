# frozen_string_literal: true

# UserSerializer
class UserSerializer < ActiveModel::Serializer
  attributes  :id, :company_id, :outlet_id, :email, :status, :created_at,
              :user_detail_attributes

  def outlet
    object.outlet
  end

  def created_at
    object.created_at.strftime('%d/%m/%Y')
  end

  def user_detail_attributes
    object.user_detail.as_json.merge(
      address_attributes: object&.user_detail&.address
    )
  end
end
