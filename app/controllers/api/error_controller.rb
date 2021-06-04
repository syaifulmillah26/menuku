# frozen_string_literal: true

module Api
  # ErrorController
  class ErrorController < Api::ApplicationController
    skip_before_action :authenticate_user

    # handling root not found
    def handle_root_not_found
      render json: {
        message: I18n.t('officer.not_found', r: 'Route')
      }, status: 404
    end
  end
end
