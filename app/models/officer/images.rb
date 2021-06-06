# frozen_string_literal: true

module Officer
  # Images
  class Images < ::Api::ApplicationController
    attr_reader :params

    def initialize(params)
      @params = params
    end

    # Image Product
    def save_product_image
      return false, { message: t('officer.invalid_params') } \
        unless product_image_params

      status, result = Officer::Outlets::Products.new(
        params
      ).grab_one

      return false, { message: I18n.t('officer.not_found', r: 'Product') } \
        unless status

      save(result)
    rescue StandardError => e
      [false, e.message]
    end

    # NPWP CARD
    def save_npwp_identity
      return false, { message: t('officer.invalid_params') } \
        unless check_params

      [true, cities]
    rescue StandardError => e
      [false, e.message]
    end

    private

    def save(object)
      object.image.attach(params[:image])
      [true, object]
    end

    # params

    def product_image_params
      return false if \
        params[:image].blank? || params[:id].blank? || \
        params[:outlet_id].blank?

      true
    end
  end
end
