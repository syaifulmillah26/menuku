# frozen_string_literal: true

module Api
  # TablesControlller
  class TablesController < Api::ResourceController
    exception = %i[show update destroy book free]
    before_action :set_object, only: exception
    before_action :validate_object, only: exception
    # Book table
    def book
      @object.booked!

      render json: { message: t('officer.success') }, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 422
    end

    # Free table
    def free
      @object.available!

      render json: { message: t('officer.success') }, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 422
    end
  end
end
