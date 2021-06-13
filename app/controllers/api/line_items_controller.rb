# frozen_string_literal: true

module Api
  # LineItemsController
  class LineItemsController < Api::ResourceController
    # Create
    def create
      @status, @result = Officer::Outlets::LineItems.new(
        params
      ).add

      return render json: @result, status: 422 unless @status

      render json: @result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 422
    end
  end
end
