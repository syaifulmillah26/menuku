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

      def send_reset_password
        @user = ::User.find_by(email: params[:email])
        return false, t('officer.account.user_not_found') if @user.blank?

        reset_password_token
      end

      def reset_password_token
        begin
          @user.reset_password_token = SecureRandom.hex(30)
          @user.reset_password_sent_at = DateTime.now
          @user.save!
          DeviseMailer.with(object: @user).reset_password_instructions.deliver_later
          return true, { message: t('officer.account.new_link_password') }
        rescue StandardError => e
          return false, e.message
        end
      end

      def save_new_password
        @user = User.find_by(email: params[:email], reset_password_token: params[:token])
        return false, t('officer.account.token_expired') unless @user

        save
      end

      def change_password
        message = t('officer.account.password_does_not_match')
        return false, { message: message } unless check_hashed_password

        save
      end

      def save
        begin
          @user.encrypted_password = hashed_password
          @user.save!
          return true, { message: t('officer.account.password_saved') }
        rescue StandardError => e
          return false, e.message
        end
      end

      private

      def hashed_password
        BCrypt::Password.create(params[:password])
      end

      def check_hashed_password
        BCrypt::Password.new(@user.encrypted_password) == params[:old_password]
      end
    end
  end
end
