# frozen_string_literal: true

module Officer
  # Images
  class Images < ::Api::ApplicationController
    attr_reader :params

    def initialize(params)
      @params = params
      @object = params[:object]
    end

    # Image Product
    def save_product_image
      return false, { message: t('officer.invalid_params') } \
        unless params[:image].present?

      save
      [true, @object]
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

    def save
      @object.image.attach(params[:image])
    end
  end
end
