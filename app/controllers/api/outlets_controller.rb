# frozen_string_literal: true

module Api
  # outlets api
  class OutletsController < Api::ResourceController
    # before_action :authenticate_user, except: %i[products product]

    # Index
    def index
      @status, @result = Officer::Outlets::Main.new(
        current_user
      ).grab_all

      return render json: @result, status: 422 unless @status

      render json: results, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 422
    end

    # get all products
    def products
      @status, @result = Officer::Outlets::Products.new(
        params
      ).grab_all

      return render json: @result, status: 422 unless @status

      render json: results, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    # get spesific products
    def product
      @status, @result = Officer::Outlets::Products.new(
        params
      ).grab_one

      return render json: @result, status: 422 unless @status

      render json: @result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
