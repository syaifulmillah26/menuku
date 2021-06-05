# frozen_string_literal: true

# ProductSerializer
class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ImageHelper
  attributes  :id, :outlet_id, :name,
              :description, :promotionable,
              :stock_availability, :price, :slug, :image

  def image
    get_image(object)
  end
end
