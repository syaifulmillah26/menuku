# frozen_string_literal: true

module Api
  # TaxonomiesController
  class TaxonomiesController < Api::ResourceController
    # get all taxonomies
    # def index
    #   @status, @result = Officer::Outlets::Taxonomies.new(
    #     params
    #   ).grab_all

    #   return render json: @result, status: 422 unless @status

    #   render json: results, status: 200
    # rescue StandardError => e
    #   render json: { message: e.message }, status: 500
    # end

    # get spesific taxonomy include taxons in trees
    # def show
    #   @status, @result = Officer::Outlets::Taxonomies.new(
    #     params
    #   ).grab_one

    #   return render json: @result, status: 422 unless @status

    #   render json: @result, status: 200
    # rescue StandardError => e
    #   render json: { message: e.message }, status: 500
    # end

    # get all products based on taxonomies
    def products
      @status, @result = Officer::Outlets::Products.new(
        params
      ).grab_products_taxons

      return render json: @result, status: 422 unless @status

      render json: results, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
