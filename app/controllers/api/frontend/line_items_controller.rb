# frozen_string_literal: true

module Api
  module Frontend
    # LineItems
    class LineItemsController < Api::Frontend::ResourceController
      # get table details
      def index
        render json: guest_access_detail, status: 200
      rescue StandardError => e
        render json: { message: e.message }, status: 500
      end

      def create
        @status, @result = Officer::Outlets::LineItems.new(
          params
        ).add

        return render json: @result, status: 422 unless @status

        render json: @result, status: 200
      rescue StandardError => e
        render json: { message: e.message }, status: 500
      end

      def update
        @status, @result = Officer::Outlets::LineItems.new(
          params
        ).update

        return render json: @result, status: 422 unless @status

        render json: @result, status: 200
      rescue StandardError => e
        render json: { message: e.message }, status: 500
      end

      def destroy
        @status, @result = Officer::Outlets::LineItems.new(
          params
        ).remove

        return render json: @result, status: 422 unless @status

        render json: @result, status: 200
      rescue StandardError => e
        render json: { message: e.message }, status: 500
      end
    end
  end
end
