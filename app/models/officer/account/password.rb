# frozen_string_literal: true

module Officer
  module Account
    # email confirmation
    class Password < ::Api::ApplicationController
      attr_reader :params
      include MailHelper

      def initialize(params)
        @params = params
        @user = params[:current_user]
      end

      # reset password
      def reset_password
        return error_message(t('officer.invalid_params')) if \
          params[:email].blank?

        @user = find_user_by_email
        return error_message(I18n.t('officer.not_found', r: 'User')) \
          unless @user

        send_reset_password_token
        [200, { message: t('officer.account.new_link_password') }]
      end

      # set new password
      def new_password
        return error_message(t('officer.invalid_params')) if \
          params[:email].blank? || params[:token].blank?

        @user = find_user_by_reset_password_token
        return error_message(t('officer.account.token_expired')) \
          unless @user

        save_password
        [200, { message: t('officer.account.password_saved') }]
      end

      # change password
      def change_password
        return error_message(t('officer.account.wrong_current_password')) \
          unless check_current_password

        save_password
        [200, { message: t('officer.account.password_saved') }]
      end

      private

      def save_password
        @user.update_column(:encrypted_password, hashed_password)
        @user.update_column(:reset_password_token, nil)
        send_mail_password_changed(@user)
      end

      def send_reset_password_token
        @user.update_column(:reset_password_token, secure_random_token)
        @user.update_column(:reset_password_sent_at, current_time)
        send_mail_instruction(@user)
      end

      def find_user_by_email
        ::User.find_by(email: params[:email])
      end

      def find_user_by_reset_password_token
        User.find_by(
          email: params[:email], reset_password_token: params[:token]
        )
      end

      def hashed_password
        BCrypt::Password.create(params[:password])
      end

      def check_current_password
        BCrypt::Password.new(@user.encrypted_password) == \
          params[:current_password]
      end
    end
  end
end
