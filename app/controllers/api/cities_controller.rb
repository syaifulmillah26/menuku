# frozen_string_literal: true

module Api
  # cities api
  class CitiesController < Api::ApplicationController
    skip_before_action :authenticate_user

    def index
      status, result = Officer::States::City.new(
        params
      ).grab_all

      render json: result, status: status
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
