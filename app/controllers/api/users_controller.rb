# frozen_string_literal: true

module Api
  # user controller
  class UsersController < Api::ResourceController
    exception = %i[create email_confirmation forgot_password set_new_password]
    before_action :authenticate_user, except: exception
    # get all users based on company
    def index
      @objects = \
        User.where(company_id: current_user&.company&.id)
      @all = total
      render json: all_datas, status: :ok
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    # activating user
    def email_confirmation
      status, result = Officer::Account::EmailConfirmation.new(
        params
      ).activate

      return render json: result, status: 422 unless status

      render json: result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    # handle forgot password
    def forgot_password
      status, result = Officer::Account::Password.new(
        params, {}
      ).reset_password

      return render json: result, status: 422 unless status

      render json: result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    # handle set new password
    def set_new_password
      status, result = Officer::Account::Password.new(
        params, {}
      ).new_password

      return render json: result, status: 422 unless status

      render json: result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
