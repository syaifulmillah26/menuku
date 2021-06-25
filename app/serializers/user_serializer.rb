# frozen_string_literal: true

# UserSerializer
class UserSerializer < ActiveModel::Serializer
  attributes :id, :company, :outlet, :email, :status
  has_one :user_detail

  def company
    object.company
  end

  def outlet
    object.outlet
  end
end
