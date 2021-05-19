# frozen_string_literal: true

module Api
  # user controller
  class UsersController < Api::ResourceController
    exception = %i[create email_confirmation forgot_password set_new_password]
    before_action :authenticate_user, except: exception

    def email_confirmation
      token = params[:token]
      return render json: t('officer.account.token_not_found') if token.blank?

      status, result = Officer::Account::EmailConfirmation.new(
        params
      ).send

      return render json: result, status: 422 unless status

      render json: result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def forgot_password
      status, result = Officer::Account::Password.new(
        params, {}
      ).send_reset_password

      return render json: result, status: 422 unless status

      render json: result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def set_new_password
      password = params[:password]
      return render json: t('officer.account.password_empty') if password.blank?

      status, result = Officer::Account::Password.new(
        params, {}
      ).save_new_password

      return render json: result, status: 422 unless status

      render json: result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
