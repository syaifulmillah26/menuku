# frozen_string_literal: true

module Api
  # PaymentMethodsController
  class PaymentMethodsController < Api::ResourceController
    skip_before_action :validate_outlet
    # Index
    def index
      @status, @result = Officer::Outlets::PaymentMethods.new(
        params
      ).grab_all

      return render json: @result, status: 422 unless @status

      render json: results, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
