# frozen_string_literal: true

module Api
  module Frontend
    # TablesController
    class TablesController < Api::Frontend::ResourceController
      # get table details
      def index
        render json: guest_access_detail, status: 200
      rescue StandardError => e
        render json: { message: e.message }, status: 500
      end
    end
  end
end
