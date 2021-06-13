# frozen_string_literal: true

module Api
  # outlets api
  class OutletsController < Api::ResourceController
    skip_before_action :authenticate_user, only: %i[create]
    skip_before_action :set_outlet_id
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
        data: serializer(current_user.outlet)
      }
    end
  end
end
