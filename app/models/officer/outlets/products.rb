# frozen_string_literal: true

module Officer
  module Outlets
    # Products
    class Products < Main
      # Grab all products based on outlet
      def grab_all
        return false, { message: t('officer.invalid_params') } if \
          params[:outlet_id].blank?

        return false, { message: I18n.t('officer.not_found', r: 'Outlet') } \
          unless outlet_id

        products
      rescue StandardError => e
        [false, e.message]
      end

      # Grab one product based on outlet
      def grab_one
        return false, { message: t('officer.invalid_params') } if \
          params[:id].blank?

        product
      rescue StandardError => e
        [false, e.message]
      end

      # grab product taxons
      def grab_products_taxons
        return false, { message: t('officer.invalid_params') } if \
          params[:outlet_id].blank? || params[:path].blank?

        return false, { message: I18n.t('officer.not_found', r: 'Outlet') } \
          unless outlet_id

        return false, { message: I18n.t('officer.not_found', r: 'Taxon') } \
          unless taxon

        products_taxons
      rescue StandardError => e
        [false, e.message]
      end

      private

      def products
        products = ::Product.where(
          outlet_id: outlet_id
        ).all

        return false, { message: t('officer.products.empty') } \
          unless products

        [true, products]
      end

      def product
        product = ::Product.where(
          outlet_id: outlet_id,
          slug: params[:id]
        )&.first

        return false, { message: t('officer.products.empty') } \
          unless product

        [true, product]
      end

      def products_taxons
        products_taxons = ::Product.where(id: product_ids).all
        return false, { message: t('officer.products.empty') } \
          unless products_taxons

        [true, products_taxons]
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
