# frozen_string_literal: true

module Api
  # Employees controller
  class EmployeesController < Api::ResourceController
    skip_before_action :set_object
    before_action :set_object_employee, only: %i[show update destroy images]
    before_action :set_company_id

    private

    def model_class
      User
    end

    def object_name
      'user'
    end

    def set_company_id
      params[object_name][:company_id] = company_id
    end
  end
end
