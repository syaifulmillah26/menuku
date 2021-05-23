# frozen_string_literal: true

module Officer
  module Account
    # email confirmation
    class Password < ::Api::ApplicationController
      include UserHelper
      attr_reader :params, :current_user

      def initialize(params, current_user)
        @params = params
        @user = current_user
      end

      # reset password
      def reset_password
        return false, { message: t('officer.invalid_params') } \
          unless reset_password_params

        @user = ::User.find_by(
          email: params[:email]
        )
        return false, { message: I18n.t('officer.not_found', r: 'User') } if \
          @user.blank?

        reset_password_token
      rescue StandardError => e
        [false, e.message]
      end

      # set new password
      def new_password
        return false, { message: t('officer.invalid_params') } \
          unless new_password_params

        @user = User.find_by(
          email: params[:email], reset_password_token: params[:token]
        )
        return false, { message: t('officer.account.token_expired') } \
          unless @user

        save
      rescue StandardError => e
        [false, e.message]
      end

      # change password
      def change_password
        return false, { message: t('officer.account.password_does_not_match') } \
          unless check_hashed_password

        save
      rescue StandardError => e
        [false, e.message]
      end

      private

      def save
        @user.encrypted_password = hashed_password
        @user.save!

        DeviseMailer.with(
          object: @user
        ).password_change.deliver_later

        [true, { message: t('officer.account.password_saved') }]
      end

      def reset_password_token
        @user.reset_password_token = SecureRandom.hex(30)
        @user.reset_password_sent_at = DateTime.now
        @user.save!

        DeviseMailer.with(
          object: @user
        ).reset_password_instructions.deliver_later

        [true, { message: t('officer.account.new_link_password') }]
      end

      def reset_password_params
        return false if params[:email].blank?

        true
      end

      def new_password_params
        return false if params[:email].blank? || params[:token].blank?

        true
      end

      def hashed_password
        BCrypt::Password.create(params[:password])
      end

      def check_hashed_password
        BCrypt::Password.new(@user.encrypted_password) == params[:old_password]
      end
    end
  end
end
