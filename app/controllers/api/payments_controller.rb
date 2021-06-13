# frozen_string_literal: true

module Api
  # PaymentsController
  class PaymentsController < Api::ResourceController
    skip_before_action :authenticate_user, only: %i[midtrans_callback]
    skip_before_action :set_object, only: %i[midtrans_callback]
    skip_before_action :set_params_outlet, only: %i[midtrans_callback]
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

    # Index
    def midtrans_callback
      @status, @result = Officer::Outlets::Payments.new(
        params
      ).midtrans_call

      return render json: @result, status: 422 unless @status

      render json: @result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
