# frozen_string_literal: true

module Officer
  module Outlets
    # Taxonomies
    class Taxonomies < Main
      def grab_all
        return false, { message: t('officer.invalid_params') } \
          unless check_params

        return false, { message: t('officer.products.taxon_not_found') } \
          unless taxonomies

        [true, taxonomies]
      rescue StandardError => e
        [false, e.message]
      end

      def taxonomies
        ::Taxonomy.where(outlet_id: outlet_id)
      end

      def check_params
        return false if \
          params[:outlet_slug].blank?

        true
      end
    end
  end
end
