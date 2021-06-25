# frozen_string_literal: true

module Api
  # ApplicationController
  class ApplicationController < ActionController::API
    include Knock::Authenticable
    include ApplicationHelper
    before_action :authenticate_user
    undef_method :current_user

    def serializer(object)
      ActiveModelSerializers::SerializableResource.new(object).as_json
    end

    def company
      current_user.company
    end

    def company_id
      company.id
    end

    def outlet
      current_user.outlet
    end

    def outlet_id
      current_user.outlet_id
    end

    def authenticate_admin
      return if current_user.is_admin?

      root_not_found
    end

    def desc(object)
      object&.order('id DESC')
    end

    def invalid_resource!(resource)
      Rails.logger.error "resouce_errors => #{resource.errors.full_messages}"
      render json: { error: resource.errors.full_messages }, status: 422
    end

    def t(data)
      I18n.t(data)
    end

    def asset_path(filename)
      ActionController::Base.helpers.asset_path(filename, digest: false)
    end

    def limit
      @objects = @objects.limit(params[:limit])
    end

    def offset
      @objects = @objects.offset(params[:offset])
    end

    def total
      @objects&.count
    end

    def result(data)
      {
        message: t('officer.success'),
        data: serializer(data)
      }
    end

    def results(datas)
      @objects = datas
      @all = total
      all_datas
    end

    def all_datas
      check_limit_and_offset
      {
        message: t('officer.success'), total: @all,
        limit: params[:limit], offset: params[:offset],
        data: serializer(desc(@objects))
      }
    end

    def check_limit_and_offset
      limit if params[:limit].present?
      offset if params[:offset].present?
    end

    def root_not_found
      render json: {
        message: I18n.t('officer.not_found', r: 'Route')
      }, status: 404
    end

    def render_error(message)
      render json: { message: message }, status: 422
    end

    def error_message(message)
      [422, { message: message }]
    end
  end
end
