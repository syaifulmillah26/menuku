# frozen_string_literal: true

module Api
  # outlets api
  class OutletsController < Api::ResourceController
    before_action :validate_company
    before_action :validate_outlet, only: %i[update destroy]
    # Index
    def index
      @status, @result = Officer::Outlets::Main.new(
        current_user
      ).grab_all

      return render json: @result, status: 422 unless @status

      render json: results, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
