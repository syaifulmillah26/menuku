# frozen_string_literal: true

module Api
  # subdistrict controller
  class SubdistrictsController < Api::ApplicationController
    before_action :authenticate_user, except: %i[index]

    def index
      status, result = Officer::States::Subdistrict.new(
        params
      ).grab_all

      render json: result, status: status
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
