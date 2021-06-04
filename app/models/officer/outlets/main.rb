# frozen_string_literal: true

module Officer
  module Outlets
    # Main
    class Main < ::Api::ApplicationController
      attr_reader :params

      def initialize(params)
        @params = params
      end

      def outlet_id
        ::Admin::Outlet.friendly.find(params[:outlet_id])&.id
      rescue ActiveRecord::RecordNotFound
        false
      end

      def taxon
        ::Taxon.joins(:taxonomy).where(
          taxonomy: { outlet_id: outlet_id }
        ).where(permalink: params[:path])&.first
      end

      def taxon_id
        taxon&.id
      end
    end
  end
end
