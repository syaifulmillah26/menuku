# frozen_string_literal: true

module Officer
  module Company
    # Main
    class Main < ::Api::ApplicationController
      attr_reader :params, :current_user

      def initialize(params, current_user)
        @params = params
        @current_user = current_user
      end

      def grab_all
        [true, @params&.company&.outlets]
      rescue StandardError => e
        [false, e.message]
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