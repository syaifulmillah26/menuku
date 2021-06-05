class OrderSerializer < ActiveModel::Serializer
  attributes  :id, :table_id, :order_number, :item_count,
              :item_total, :total, :additional_tax,
              :additional_services, :promo_total,
              :status
end
