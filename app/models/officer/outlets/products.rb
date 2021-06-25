# frozen_string_literal: true

module Officer
  module Outlets
    # Products
    class Products < Main
      # Grab all products based on outlet
      def grab_all
        return error_message(t('officer.invalid_params')) if \
          params[:outlet_id].blank?

        return error_message(I18n.t('officer.not_found', r: 'Outlet')) \
          unless outlet_id

        [200, results(products)]
      end

      # Grab one product based on outlet
      def grab_one
        return error_message(t('officer.invalid_params')) if \
          params[:id].blank?

        [200, result(product)]
      end

      # grab product taxons
      def grab_products_taxons
        return error_message(t('officer.invalid_params')) if \
          params[:path].blank?
        return error_message(I18n.t('officer.not_found', r: 'Taxon'))  \
          unless taxon

        [true, results(products_taxons)]
      end

      private

      def products
        ::Product.where(
          outlet_id: outlet_id
        ).all
      end

      def product
        ::Product.where(
          outlet_id: outlet_id,
          slug: params[:id]
        )&.first
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
    end
  end
end
