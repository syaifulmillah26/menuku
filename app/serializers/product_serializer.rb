# frozen_string_literal: true

# ProductSerializer
class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ImageHelper
  attributes :id, :outlet_id, :name, :description, :promotionable, :slug, :image

  def image
    get_image(object)
  end
end
