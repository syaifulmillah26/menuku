class TableSerializer < ActiveModel::Serializer
  attributes :id, :outlet_id, :guest_access, :table_number, :seat, :status,  :active_order
end
