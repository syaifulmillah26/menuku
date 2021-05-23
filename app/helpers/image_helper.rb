# frozen_string_literal: true

# Tablename "company_details"

# ===== Columns ===== #

# helper
module ImageHelper
  Rails.application.routes.url_helpers

  def get_image(object)
    return if object.image.blank?

    img = object.image
    image = {}
    image[:id] = img.id
    image[:record_type] = img.record_type
    image[:image_url] = rails_blob_path(img, only_path: true)

    image
  end
end
