# frozen_string_literal: true

module Api
  # profile controller
  class ProfileController < Api::ResourceController
    # show user profile
    def index
      user = current_user
      data = { message: t('officer.account.success'), data: serializer(user) }
      render json: data, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    # update user password
    def update_password
      status, result = Officer::Account::Password.new(
        params, current_user
      ).change_password

      return render json: result, status: 422 unless status

      render json: result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    # update user profile
    def update_profile
      status, result = Officer::Account::Profile.new(
        params, current_user
      ).update_user_detail

      return render json: result, status: 422 unless status

      render json: result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
