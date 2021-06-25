# frozen_string_literal: true

module Api
  # Employees controller
  class EmployeesController < Api::ResourceController
    before_action :set_company_id, only: :create

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
