# frozen_string_literal: true

module Api
  # TaxonomiesController
  class TaxonomiesController < Api::ResourceController
    before_action :authenticate_user, except: %i[index show]
    def index
      @status, @result = Officer::Outlets::Taxonomies.new(
        params
      ).grab_all

      return render json: @result, status: 422 unless @status

      render json: @result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def show
      @status, @result = Officer::Outlets::Taxons.new(
        params
      ).grab_all

      return render json: @result, status: 422 unless @status

      render json: @result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def products
      @status, @result = Officer::Outlets::ProductTaxons.new(
        params
      ).all_products

      return render json: @result, status: 422 unless @status

      render json: results, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
