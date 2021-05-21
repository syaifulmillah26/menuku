class CompanyDetailSerializer < ActiveModel::Serializer
  attributes :id, :npwp, :data_filled, :address
end
