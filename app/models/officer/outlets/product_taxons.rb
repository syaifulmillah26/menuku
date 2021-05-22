# frozen_string_literal: true

module Officer
  module Outlets
    # Products
    class ProductTaxons < Main
      def all_products
        return false, { message: t('officer.invalid_params') } \
          unless check_params

        return false, { message: t('officer.products.taxon_not_found') } \
         unless taxon

        begin
          products
        rescue StandardError => e
          return false, e.message
        end
      end

      def products
        return false, { message: t('officer.products.empty') } \
          unless products_taxons

        [true, products_taxons]
      end

      def products_taxons
        ::Product.where(id: product_ids).all
      end

      def product_ids
        classification.map(&:product_id)
      end

      def classification
        ::Classification.where(taxon_id: taxon_id)
      end

      def check_params
        return false if \
          params[:outlet_slug].blank?

        return false if \
          params[:path].blank?

        true
      end
    end
  end
end
