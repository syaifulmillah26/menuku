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
      return error_message(t('officer.invalid_params')) \
        unless params[:image].present?

      save
      [200, @object]
    end

    # NPWP CARD
    def save_npwp_identity
      return error_message(t('officer.invalid_params')) \
        unless check_params

      [200, cities]
    end

    private

    def save
      @object.image.attach(params[:image])
    end
  end
end
