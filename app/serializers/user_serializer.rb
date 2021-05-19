class UserSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :email, :status
  has_one :user_detail
end
