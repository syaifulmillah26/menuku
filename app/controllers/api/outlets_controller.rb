# frozen_string_literal: true

module Api
  # outlets api
  class OutletsController < Api::ResourceController
    skip_before_action :authenticate_user, only: %i[create]
    skip_before_action :set_outlet_id
    skip_before_action :set_params_outlet
    before_action :set_object
    before_action :validate_object, only: %i[show update destroy]
    # Index
    def index
      render json: load_data, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def load_data
      {
        message: t('officer.success'),
        data: serializer(outlet)
      }
    end

    def set_object
      @object = outlet
    rescue StandardError => e
      render json: { error: e.message }, status: 500
    end
  end
end
