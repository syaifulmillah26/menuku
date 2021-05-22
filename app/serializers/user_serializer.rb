class UserSerializer < ActiveModel::Serializer
  attributes :id, :company_id, :email, :status
  has_one :user_detail
end
