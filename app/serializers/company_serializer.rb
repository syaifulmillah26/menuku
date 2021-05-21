class CompanySerializer < ActiveModel::Serializer
  attributes :id, :company_name, :business_type, :status
  has_one :company_detail
  has_many :outlets
end
