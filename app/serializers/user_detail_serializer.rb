class UserDetailSerializer < ActiveModel::Serializer
  attributes :id, :firstname, :lastname, :address
end
