# frozen_string_literal: true

module Api
  # CompanyController
  class MyCompanyController < Api::ResourceController
    def index
      company = current_user.company
      data = { message: t('officer.account.success'), data: serializer(company) }
      render json: data, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
