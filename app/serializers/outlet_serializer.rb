# frozen_string_literal: true

# OutletSerializer
class OutletSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :address, :admin_outlet, :employees, :products
end
