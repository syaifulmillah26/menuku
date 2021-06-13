class OrderSerializer < ActiveModel::Serializer
  attributes  :id, :table_id, :number, :item_count,
              :item_total, :total, :tax_and_service,
              :tax_and_service_included, :promo_total,
              :status

  def tax_and_service_included
    object&.tax_and_service_included
  end
end
