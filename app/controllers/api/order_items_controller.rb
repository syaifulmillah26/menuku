# frozen_string_literal: true

module Api
  # OrderItemsController
  class OrderItemsController < Api::ResourceController
    # Index
    def index
      @status, @result = Officer::Outlets::OrderItems.new(
        params
      ).grab_all

      return render json: @result, status: 422 unless @status

      render json: results, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 422
    end

    # Create
    def create
      @status, @result = Officer::Outlets::OrderItems.new(
        params
      ).add

      return render json: @result, status: 422 unless @status

      render json: @result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 422
    end
  end
end
