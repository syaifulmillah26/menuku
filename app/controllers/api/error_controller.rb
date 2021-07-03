# frozen_string_literal: true

module Api
  # ErrorController
  class ErrorController < Api::ApplicationController
    skip_before_action :authenticate_user

    # handling root not found
    def handle_root_not_found
      root_not_found
    end
  end
end
