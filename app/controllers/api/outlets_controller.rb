# frozen_string_literal: true

module Api
  # outlets api
  class OutletsController < Api::ResourceController
    before_action :authenticate_user, except: %i[index show]
    def index
      @objects = current_user&.company&.outlets
      @all = total
      render json: all_datas, status: :ok
    rescue StandardError => e
      render json: { message: e.message }, status: 422
    end
  end
end
