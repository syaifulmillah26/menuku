# frozen_string_literal: true

module Officer
  module Account
    # email confirmation
    class Password < ::Api::ApplicationController
      attr_reader :params, :current_user

      def initialize(params, current_user)
        @params = params
        @user = current_user
      end

      # reset password
      def reset_password
        return false, { message: t('officer.invalid_params') } if \
          params[:email].blank?

        @user = find_user_by_email
        return false, { message: I18n.t('officer.not_found', r: 'User') } \
          unless @user

        send_reset_password_token
      rescue StandardError => e
        [false, e.message]
      end

      # set new password
      def new_password
        return false, { message: t('officer.invalid_params') } if \
          params[:email].blank? || params[:token].blank?

        @user = find_user_by_reset_password_token
        return false, { message: t('officer.account.token_expired') } \
          unless @user

        save_password
      rescue StandardError => e
        [false, e.message]
      end

      # change password
      def change_password
        return false, { message: t('officer.account.wrong_current_password') } \
          unless check_current_password

        save_password
      rescue StandardError => e
        [false, e.message]
      end

      private

      def save_password
        @user.encrypted_password = hashed_password
        @user.save!

        DeviseMailer.with(
          object: @user
        ).password_change.deliver_later

        [true, { message: t('officer.account.password_saved') }]
      end

      def send_reset_password_token
        @user.reset_password_token = secure_random_token
        @user.reset_password_sent_at = current_time
        @user.save!

        DeviseMailer.with(
          object: @user
        ).reset_password_instructions.deliver_later

        [true, { message: t('officer.account.new_link_password') }]
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
