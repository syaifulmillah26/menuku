# frozen_string_literal: true

module Officer
  module Outlets
    # Products
    class Products < Main
      def grab_all
        return false, { message: t('officer.invalid_params') } \
          unless check_params

        begin
          products
        rescue StandardError => e
          return false, e.message
        end
      end

      def grab_one
        return false, { message: t('officer.invalid_params') } \
        unless check_params_id

        begin
          product
        rescue StandardError => e
          return false, e.message
        end
      end

      def product
        return false, { message: t('officer.products.empty') } \
          unless one_product

        [true, serializer(one_product)]
      end

      def products
        return false, { message: t('officer.products.empty') } \
          unless all_products

        [true, all_products]
      end

      def one_product
        ::Product.where(
          outlet_id: outlet_id,
          id: params[:product_id]
        )&.first
      end

      def all_products
        ::Product.where(outlet_id: outlet_id).all
      end

      def check_params
        return false if \
          params[:outlet_slug].blank?

        true
      end

      def check_params_id
        return false if \
          params[:outlet_slug].blank?

        return false if \
          params[:product_id].blank?

        true
      end
    end
  end
end
