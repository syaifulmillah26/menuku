# frozen_string_literal: true

module Officer
  module Account
    # email confirmation
    class EmailConfirmation < ::Api::ApplicationController
      attr_reader :params
      include MailHelper

      def initialize(params)
        @params = params
      end

      # activate
      def activate
        return error_message(I18n.t('officer.not_found', r: 'Token')) if \
          params[:token].blank?
        return error_message(I18n.t('officer.not_found', r: 'User')) \
          unless user

        user.confirm!
        send_mail_activated(user)
        [200, { message: t('officer.account.email.activate') }]
      end

      private

      def user
        ::User.find_by(confirmation_token: params[:token])
      end
    end
  end
end
