# frozen_string_literal: true

module Api
  # CompanyController
  class CompanyController < Api::ResourceController
    before_action :authenticate_user

    def index
      user = current_user.company
      data = { message: t('officer.account.success'), data: serializer(user) }
      render json: data, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def update_company
      render json: { message: 'on progress' }, status: 200
      # status, result = Officer::Account::Password.new(
      #   params, current_user
      # ).change_password

      # return render json: result, status: 422 unless status

      # render json: result, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
