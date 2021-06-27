# frozen_string_literal: true

# UserSerializer
class UserSerializer < ActiveModel::Serializer
  attributes :id, :company_id, :outlet, :email, :status, :created_at
  has_one :user_detail

  def outlet
    object.outlet
  end

  def created_at
    object.created_at.strftime('%d/%m/%Y')
  end
end
