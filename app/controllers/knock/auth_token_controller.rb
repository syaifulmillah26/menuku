# frozen_string_literal: true

require_dependency 'knock/application_controller'
# module
module Knock
  # knock gem
  class AuthTokenController < ApplicationController
    before_action :authenticate

    def create
      render json: auth_token, status: :created
    end

    private

    def authenticate
      data = { message: 'Your Company banned' }
      return render json: data, status: 422 if entity.company.inactive?

      data = { message: 'Please ask your admin to activate your account' }
      return render json: data, status: 422 if entity.inactive?

      wrong_email_or_pass = entity.authenticate(auth_params[:password])
      data = { message: 'Wrong email or password' }
      return render json: data, status: 422 unless wrong_email_or_pass
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def auth_token
      if entity.respond_to? :to_token_payload
        AuthToken.new payload: entity.to_token_payload
      else
        AuthToken.new payload: { sub: entity.id }
      end
    end

    def entity
      @entity ||=
        if entity_class.respond_to? :from_token_request
          entity_class.from_token_request request
        else
          entity_class.find_by email: auth_params[:email]
        end
    end

    def entity_class
      entity_name.constantize
    end

    def entity_name
      self.class.name.scan(/\w+/).last.split('TokenController').first
    end

    def auth_params
      params.require(:auth).permit :email, :password
    end
  end
end
