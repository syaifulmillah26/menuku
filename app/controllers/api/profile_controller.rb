# frozen_string_literal: true

module Api
  # profile controller
  class ProfileController < Api::ResourceController
    before_action :set_user_params

    def index
      render json: user_data, status: 200
    rescue StandardError => e
      render json: { error: e.message }, status: 500
    end

    def update_password
      condition = params[:password] == params[:password_confirmation]
      return render_error(t('officer.account.password_does_not_match')) \
        unless condition

      status, result = Officer::Account::Password.new(
        params
      ).change_password

      render json: result, status: status
    rescue StandardError => e
      render json: { error: e.message }, status: 500
    end

    def update_profile
      status, result = Officer::Account::Profile.new(
        params
      ).update

      render json: result, status: status
    rescue StandardError => e
      render json: { error: e.message }, status: 500
    end

    private

    def set_user_params
      params[:current_user] = current_user
    end

    def user_data
      {
        message: t('officer.account.success'),
        data: serializer(current_user)
      }
    end
  end
end
