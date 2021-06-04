# frozen_string_literal: true

module Officer
  module Account
    # email confirmation
    class EmailConfirmation < ::Api::ApplicationController
      attr_reader :params

      def initialize(params)
        @params = params
      end

      # activate
      def activate
        return false, { message: I18n.t('officer.not_found', r: 'Token') } if \
          params[:token].blank?

        return false, { message: I18n.t('officer.not_found', r: 'User') } \
          unless user

        user.confirm!
        DeviseMailer.with(object: user).activated_email.deliver_later

        [true, { message: t('officer.account.email.activate') }]
      rescue StandardError => e
        [false, e.message]
      end

      private

      def user
        ::User.find_by(confirmation_token: params[:token])
      end
    end
  end
end
