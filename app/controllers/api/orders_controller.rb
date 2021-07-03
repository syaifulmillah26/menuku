# frozen_string_literal: true

module Api
  # OrdersCOntroller
  class OrdersController < Api::ResourceController
    exception = %i[show update destroy confirm_order finish_order]
    before_action :set_object, only: exception
    before_action :validate_object, only: exception

    # confirming order
    def confirm_order
      status, result = Officer::Outlets::Orders.new(
        params
      ).confirm

      render json: result, status: status
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def finish_order
      status, result = Officer::Outlets::Orders.new(
        params
      ).done

      render json: result, status: status
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
