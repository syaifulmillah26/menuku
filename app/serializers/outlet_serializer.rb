class OutletSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :address, :admin_outlet, :employees
end
