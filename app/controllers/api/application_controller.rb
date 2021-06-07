# frozen_string_literal: true

module Api
  # ApplicationController
  class ApplicationController < ActionController::API
    include Knock::Authenticable
    include ApplicationHelper
    before_action :authenticate_user
    undef_method :current_user

    def admin_permission
      current_user.is_admin?
    end

    def serializer(object)
      ActiveModelSerializers::SerializableResource.new(object).as_json
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

    def validate_outlet
      outlet = Admin::Outlet.where(slug: params[:outlet_id])&.first
      return root_not_found if \
        current_user&.company&.id != outlet&.company_id
    rescue StandardError => e
      render json: { message: e.message }, status: 500
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

    def results
      @objects = @result
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
  end
end
