# frozen_string_literal: true

module Api
  # CompaniesController
  class CompaniesController < Api::ResourceController
    skip_before_action :authenticate_user
  end
end