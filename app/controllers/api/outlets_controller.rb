# frozen_string_literal: true

module Api
  # outlets api
  class OutletsController < Api::ResourceController
    skip_before_action :authenticate_user
    def index
      @objects = current_user.company.outlets
      @all = total
      if params[:province_id].present?
        @objects = Admin::City.where(province_id: params[:province_id])
      end
      render json: all_datas, status: :ok
    rescue StandardError => e
      render json: { message: e.message }, status: 422
    end
  end
end
