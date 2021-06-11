# frozen_string_literal: true

module Api
  # PaymentsController
  class PaymentsController < Api::ResourceController
    # Index
    def index
      @status, @result = Officer::Outlets::Payments.new(
        params
      ).grab_all

      return render json: @result, status: 422 unless @status

      render json: results, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
