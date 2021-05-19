# frozen_string_literal: true

module Api
  # CompaniesController
  class CompaniesController < Api::ResourceController
    exception = %i[create]
    before_action :authenticate_user, except: exception

    def index
      user = current_user.company
      data = { message: t('officer.account.success'), data: serializer(user) }
      render json: data, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
