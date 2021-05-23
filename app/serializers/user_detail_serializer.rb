# frozen_string_literal: true

# UserSerializer
class UserDetailSerializer < ActiveModel::Serializer
  attributes :id, :fullname, :address
end
