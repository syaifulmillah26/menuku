# frozen_string_literal: true

module Api
  # OrdersCOntroller
  class OrdersController < Api::ResourceController
    before_action :set_object, only: %i[show update destroy confirm_order finish_order]
    before_action :validate_object, only: %i[show update destroy confirm_order finish_order]

    # confirming order
    def confirm_order
      @status, @result = Officer::Outlets::Orders.new(
        params
      ).confirm

      return render json: @result, status: 422 unless @status

      render json: @result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def finish_order
      @status, @result = Officer::Outlets::Orders.new(
        params
      ).done

      return render json: @result, status: 422 unless @status

      render json: @result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
