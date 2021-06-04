# frozen_string_literal: true

module Api
  # CompanyController
  class MyCompanyController < Api::ResourceController
    # get company
    def index
      data = { message: t('officer.account.success'), data: serializer(current_user) }
      render json: data, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
