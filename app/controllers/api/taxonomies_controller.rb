# frozen_string_literal: true

module Api
  # TaxonomiesController
  class TaxonomiesController < Api::ResourceController
    # get spesific taxonomy include taxons in trees
    def show
      status, result = Officer::Outlets::Taxonomies.new(
        params
      ).grab_one

      render json: result, status: status
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    # get all products based on taxonomies
    def products
      status, result = Officer::Outlets::Products.new(
        params
      ).grab_products_taxons

      render json: result, status: status
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
