# frozen_string_literal: true

module Api
  # province controller
  class ProvincesController < Api::ApplicationController
    skip_before_action :authenticate_user

    def index
      status, result = Officer::States::Province.new(
        params
      ).grab_all

      render json: result, status: status
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
