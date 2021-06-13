# frozen_string_literal: true

module Api
  # resource class
  class ResourceController < Api::ApplicationController
    before_action :authenticate_user
    before_action :set_params_outlet
    before_action :set_object, only: %i[show update destroy]
    before_action :validate_object, only: %i[show update destroy]
    before_action :set_outlet_id, only: %i[create]
    helper_method :permitted_resource_params

    def index
      @result = model_class.where(outlet_id: outlet_id)

      render json: results, status: 200
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
      @object.destroy!
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
      return @object = friendly_object if friendly_object

      @object = model_class.find_by(
        id: params[:id],
        outlet_id: outlet_id
      )
    rescue StandardError => e
      render json: { error: e.message }, status: 500
    end

    def friendly_object
      model_class.friendly.find(params[:id]) if \
        model_class == Product
    end

    def validate_object
      message = { message: "#{model_class.model_name.human} not found" }
      return render json: message, status: 400 if @object.blank?
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

    def set_outlet_id
      params[object_name][:outlet_id] = outlet_id
    end

    def set_params_outlet
      params[:outlet] = outlet
    end
  end
end
