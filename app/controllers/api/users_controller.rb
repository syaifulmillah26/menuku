# frozen_string_literal: true

module Api
  # user controller
  class UsersController < Api::ResourceController
    exception = %i[create email_confirmation forgot_password set_new_password]
    before_action :authenticate_user, except: exception
    before_action :set_params_outlet, except: exception
    before_action :set_objects, only: :index
    # get all users based on company
    def index
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

      render json: result, status: status
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    # handle forgot password
    def forgot_password
      status, result = Officer::Account::Password.new(
        params
      ).reset_password

      render json: result, status: status
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    # handle set new password
    def set_new_password
      status, result = Officer::Account::Password.new(
        params
      ).new_password

      render json: result, status: status
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def set_objects
      @objects = User.where(company_id: current_user&.company&.id)
    end
  end
end
