# frozen_string_literal: true

module Api
  module Frontend
    # OrdersCOntroller
    class OrdersController < Api::Frontend::ResourceController
      # Index
      def index
        @status, @result = Officer::Outlets::Orders.new(
          params
        ).grab_all

        return render json: @result, status: 422 unless @status

        render json: results, status: 200
      rescue StandardError => e
        render json: { message: e.message }, status: 422
      end

      def show
        @status, @result = Officer::Outlets::Orders.new(
          params
        ).grab_one

        return render json: @result, status: 422 unless @status

        render json: @result, status: 200
      rescue StandardError => e
        render json: { message: e.message }, status: 422
      end

      def update
        @status, @result = Officer::Outlets::Orders.new(
          params
        ).update_order

        return render json: @result, status: 422 unless @status

        render json: @result, status: 200
      rescue StandardError => e
        render json: { message: e.message }, status: 422
      end

      def confirm_order
        @status, @result = Officer::Outlets::Orders.new(
          params
        ).confirm

        return render json: @result, status: 422 unless @status

        render json: @result, status: 200
      rescue StandardError => e
        render json: { message: e.message }, status: 422
      end
    end
  end
end
