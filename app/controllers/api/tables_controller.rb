# frozen_string_literal: true

module Api
  # TablesControlller
  class TablesController < Api::ResourceController
    # Index
    def index
      @status, @result = Officer::Outlets::Tables.new(
        params
      ).grab_all

      return render json: @result, status: 422 unless @status

      render json: results, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 422
    end
  end
end
