# frozen_string_literal: true

module Api
  # Employees controller
  class EmployeesController < Api::ResourceController
    skip_before_action :set_object
    before_action :set_object_employee, only: %i[show update destroy images]
    # get all users based on company
    def index
      @status, @result = Officer::Outlets::Employees.new(
        current_user
      ).grab_all

      return render json: @result, status: 422 unless status

      render json: results, status: 200
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def set_object_employee
      @object = User.find(params[:id])
    rescue StandardError => e
      render json: { error: e.message }, status: 500
    end

    def model_class
      User
    end

    def object_name
      'user'
    end
  end
end
