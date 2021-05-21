# frozen_string_literal: true

module Api
  # ErrorController
  class ErrorController < Api::ApplicationController
    skip_before_action :authenticate_user
    def handle_root_not_found
      render json: { message: 'route not found' }, status: 404
    end
  end
end
