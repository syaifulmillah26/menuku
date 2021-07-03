# frozen_string_literal: true

module Officer
  # Main
  class States < ::Api::ApplicationController
    attr_reader :params

    def initialize(params)
      @params = params
    end

    # Main
    class Province < States
      def grab_all
        [200, results(provinces)]
      end

      private

      def provinces
        ::Admin::Province.all
      end
    end

    # Main
    class City < States
      def grab_all
        return error_message(t('officer.invalid_params')) \
          unless params[:province_id].present?

        [200, results(cities)]
      end

      private

      def cities
        ::Admin::City.where(province_id: params[:province_id])
      end
    end

    # Main
    class Subdistrict < States
      def grab_all
        return error_message(t('officer.invalid_params')) \
          unless params[:city_id].present?

        [200, results(subdistricts)]
      end

      private

      def subdistricts
        ::Admin::Subdistrict.where(city_id: params[:city_id])
      end
    end
  end
end
