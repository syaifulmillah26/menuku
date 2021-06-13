# frozen_string_literal: true

# UserSerializer
class UserSerializer < ActiveModel::Serializer
  attributes :id, :company, :outlet_id, :email, :roles, :status
  has_one :user_detail

  def company
    object.company
  end
end
