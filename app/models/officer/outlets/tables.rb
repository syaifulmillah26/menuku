# frozen_string_literal: true

module Officer
  module Outlets
    # Tables
    class Tables < Main
      # grab all tables
      def grab_all
        return false, { message: t('officer.invalid_params') } if \
          params[:outlet_id].blank?

        [true, tables]
      rescue StandardError => e
        [false, e.message]
      end

      private

      def tables
        ::Table.where(outlet_id: outlet_id)
      end
    end
  end
end
