# frozen_string_literal: true

module Api
  module Frontend
    # resource class
    class ResourceController < Api::ApplicationController
      skip_before_action :authenticate_user
      before_action :check_guest_token

      def check_guest_token
        return render json: { message: t('officer.invalid_guest_access') }, status: 401 \
        unless guest_access
      end

      def guest_access
        Table.where(
          guest_access: params[:guest_access],
          outlet_id: params[:outlet_id]
        )&.first
      end

      def guest_access_detail
        {
          message: 'success',
          data: serializer(guest_access)
        }
      end
    end
  end
end
