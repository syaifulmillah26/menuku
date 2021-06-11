# frozen_string_literal: true

module Officer
  module Outlets
    # Tables
    class Tables < Main
      # grab all tables
      def grab_all
        [true, tables]
      rescue StandardError => e
        [false, { message: e.message }]
      end

      def book_table
        return false, { message: t('officer.invalid_params') } if \
          params[:id].blank?

        table.booked!
        [true, table]
      rescue StandardError => e
        [false, { message: e.message }]
      end

      def free_table
        return false, { message: t('officer.invalid_params') } if \
          params[:id].blank?

        table.available!
        [true, table]
      rescue StandardError => e
        [false, { message: e.message }]
      end

      private

      def tables
        ::Table.where(outlet_id: outlet_id)
      end

      def table
        ::Table.find(params[:id])
      end
    end
  end
end
