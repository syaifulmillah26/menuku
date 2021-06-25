# frozen_string_literal: true

# require_dependency 'knock/application_controller'
# module
module Knock
  # knock gem
  class AuthTokenController < ApplicationController
    before_action :authenticate

    def create
      render json: token, status: :created
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def authenticate
      entity?
    end

    def token
      {
        message: 'success',
        auth_token: auth_token&.token
      }
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

    def entity?
      data = { message: t('officer.account.email.not_registered') }
      return render json: data, status: 422 unless entity

      inactive_entity?
    end

    def inactive_entity?
      data = { message: t('officer.account.email.inactive') }
      return render json: data, status: 422 if entity.inactive?

      valid_password?
    end

    def valid_password?
      valid_password = entity.authenticate(auth_params[:password])
      data = { message: t('officer.account.wrong_password') }
      return render json: data, status: 422 unless valid_password
    end

    # def inactive_company?
    #   data = { message: 'Your Company banned' }
    #   return render json: data, status: 422 if entity.company.inactive?

    #   wrong_email_or_pass?
    # end
  end
end
