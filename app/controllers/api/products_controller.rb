# frozen_string_literal: true

module Api
  # ProductsController
  class ProductsController < Api::ResourceController
    before_action :authenticate_user, except: %i[index show]

    # show all products based on outlets
    def index
      @status, @result = Officer::Outlets::Products.new(
        params
      ).grab_all

      return render json: @result, status: 422 unless @status

      render json: results, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    # get spesific product
    def show
      @status, @result = Officer::Outlets::Products.new(
        params
      ).grab_one

      return render json: @result, status: 422 unless @status

      render json: serializer(@result), status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    # set image for product
    def set_product_image
      @status, @result = Officer::Images.new(
        params
      ).save_product_image

      return render json: @result, status: 422 unless @status

      render json: serializer(@result), status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
