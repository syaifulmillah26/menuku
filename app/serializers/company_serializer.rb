class CompanySerializer < ActiveModel::Serializer
  attributes :id, :company_name, :registration_id, :status
  has_one :company_detail
  has_many :outlets
end
