# frozen_string_literal: true

module Api
  # OmniauthCallbacksController
  class OmniauthController < Api::ResourceController
    skip_before_action :authenticate_user
    skip_before_action :validate_outlet

    # set login provider
    def request_provider
      @status, @result = Officer::Account::Omniauth.new(
        params
      ).exchange_token

      return render json: @result, status: 422 unless @status

      render json: @result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
