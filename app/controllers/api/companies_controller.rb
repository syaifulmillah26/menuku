# frozen_string_literal: true

module Api
  # CompaniesController
  class CompaniesController < Api::ResourceController
    skip_before_action :validate_outlet
    before_action :set_admin_permission
  end
end
