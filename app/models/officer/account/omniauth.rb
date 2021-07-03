# frozen_string_literal: true

require 'httparty'

module Officer
  module Account
    # email confirmation
    class Omniauth < ::Api::ApplicationController
      attr_reader :params

      def initialize(params)
        @params = params
      end

      # exchange_token
      def exchange_token
        return error_message(I18n.t('officer.not_found', r: 'Token')) \
        unless param_exists

        @response = condition ? get(google_url) : get(facebook_url)
        return error_message('invalid token') if @response.code != 200

        [200, token]
      end

      private

      def condition
        params[:provider] == 'google'
      end

      def get(url)
        HTTParty.get(url)
      end

      def google_url
        ENV['GOOGLE_OAUTH2_URL'] + params['token']
      end

      def facebook_url
        ENV['FACEBOOK_OAUTH2_URL'] + params['token']
      end

      def set_user
        @user = User.create_user_provider(
          @response.parsed_response,
          params[:provider]
        )
      end

      def token
        set_user
        {
          message: t('officer.success'),
          auth_token: auth_token&.token
        }
      end

      def auth_token
        Knock::AuthToken.new payload: { sub: @user.id }
      end

      def param_exists
        return true if params[:token].present? || params[:provider].present?

        false
      end
    end
  end
end
