# frozen_string_literal: true

module Api
  # LineItemsController
  class LineItemsController < Api::ResourceController
    # Create
    def create
      status, result = Officer::Outlets::LineItems.new(
        params
      ).add

      render json: result, status: status
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
