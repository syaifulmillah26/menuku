# frozen_string_literal: true

module Api
  # OrdersCOntroller
  class OrdersController < Api::ResourceController
    # Index
    def index
      @status, @result = Officer::Outlets::Orders.new(
        params
      ).grab_all

      return render json: @result, status: 422 unless @status

      render json: results, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def create
      @status, @result = Officer::Outlets::Orders.new(
        params
      ).create
      return render json: @result, status: 422 unless @status

      render json: @result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def show
      @status, @result = Officer::Outlets::Orders.new(
        params
      ).grab_one

      return render json: @result, status: 422 unless @status

      render json: @result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def update
      @status, @result = Officer::Outlets::Orders.new(
        params
      ).update_order

      return render json: @result, status: 422 unless @status

      render json: @result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

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
