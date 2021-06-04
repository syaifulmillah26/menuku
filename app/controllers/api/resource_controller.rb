# frozen_string_literal: true

module Api
  # resource class
  class ResourceController < Api::ApplicationController
    before_action :authenticate_user
    before_action :set_object, only: %i[show update destroy images]
    helper_method :permitted_resource_params

    def index
      @objects = model_class.all
      @all = total
      render json: all_datas, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def new
      render model_class.new
    end

    def create
      @object = model_class.create(permitted_resource_params)
      instance_variable_set("@#{object_name}", @object)
      return invalid_resource!(@object) unless @object.save

      data = { message: t('officer.success'), data: serializer(@object) }
      render json: data, status: 201
    rescue StandardError => e
      render json: { error: e.message }, status: 500
    end

    def show
      data = { message: t('officer.success'), data: serializer(@object) }
      render json: data, status: 200
    rescue StandardError => e
      render json: { error: e.message }, status: 500
    end

    def update
      permit = permitted_resource_params
      return invalid_resource!(@object) unless @object.update(permit)

      data = { message: t('officer.success'), data: serializer(@object) }
      render json: data, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: 500
    end

    def destroy
      data = { message: 'You have no right to do this' }
      return render json: data, status: 422 unless admin_permission

      return invalid_resource!(@object) unless @object.destroy

      render json: { message: t('officer.success') }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: 500
    end

    def update_positions
      ActiveRecord::Base.transaction do
        params[:positions].each do |id, index|
          model_class.find_by(id: id)&.update(position: index)
        end
      end

      render json: { message: t('officer.success') }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: 500
    end

    private

    def set_object
      return @object = model_class.friendly.find(params[:id]) if \
        model_class == Admin::Outlet || model_class == Product

      @object = model_class.find(params[:id])
    rescue StandardError => e
      render json: { error: e.message }, status: 500
    end

    def permitted_resource_params
      acp = ActionController::Parameters.new.permit!
      params[object_name].present? ? params.require(object_name).permit! : acp
    end

    def model_class
      return admin_class if \
        controller_name.classify.to_s == 'Outlet' || \
        controller_name.classify.to_s == 'Company'

      controller_name.classify.to_s.constantize
    end

    def admin_class
      admin = 'Admin::' + controller_name.classify.to_s
      admin.constantize
    end

    def object_name
      controller_name.singularize
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
  end
end
