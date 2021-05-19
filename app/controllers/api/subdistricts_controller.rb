# frozen_string_literal: true

module Api
  # subdistrict controller
  class SubdistrictsController < Api::ResourceController
    skip_before_action :authenticate_user
    def index
      @objects = Admin::Subdistrict.all
      @all = total
      if params[:city_id].present?
        @objects = Admin::Subdistrict.where(city_id: params[:city_id])
      end
      render json: all_datas, status: :ok
    rescue StandardError => e
      render json: { message: e.message }, status: 422
    end
  end
end
