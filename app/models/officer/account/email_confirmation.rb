# frozen_string_literal: true

module Officer
  module Account
    # email confirmation
    class EmailConfirmation < ::Api::ApplicationController
      attr_reader :params

      def initialize(params)
        @params = params
      end

      def send
        user = ::User.find_by(confirmation_token: params[:token])
        return false, t('officer.account.user_not_found') unless user

        begin
          user.confirm!
          DeviseMailer.with(object: user).activated_email.deliver_later
          data = { message: t('officer.account.email.activate') }
          return true, data
        rescue StandardError => e
          return false, e.message
        end
      end
    end
  end
end
