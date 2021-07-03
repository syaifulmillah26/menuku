# frozen_string_literal: true

module Api
  # OmniauthCallbacksController
  class OmniauthController < Api::ResourceController
    skip_before_action :authenticate_user

    # set login provider
    def request_provider
      status, result = Officer::Account::Omniauth.new(
        params
      ).exchange_token

      render json: result, status: status
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
