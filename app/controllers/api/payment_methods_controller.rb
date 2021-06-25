# frozen_string_literal: true

module Api
  # PaymentMethodsController
  class PaymentMethodsController < Api::ResourceController
    # Index
    def index
      status, result = Officer::Outlets::PaymentMethods.new(
        params
      ).grab_all

      render json: result, status: status
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
