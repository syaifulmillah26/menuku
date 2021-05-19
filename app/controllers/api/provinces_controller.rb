# frozen_string_literal: true

module Api
  # province controller
  class ProvincesController < Api::ResourceController
    skip_before_action :authenticate_user
    def index
      @objects = Admin::Province.all
      @all = total
      render json: all_datas, status: :ok
    rescue StandardError => e
      render json: { message: e.message }, status: 422
    end
  end
end
