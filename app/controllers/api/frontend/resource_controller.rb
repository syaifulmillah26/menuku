# frozen_string_literal: true

module Api
  module Frontend
    # resource class
    class ResourceController < Api::ApplicationController
      skip_before_action :authenticate_user
      # before_action :check_guest_token

      def limit
        @objects = @objects.limit(params[:limit])
      end

      def offset
        @objects = @objects.offset(params[:offset])
      end

      def total
        @objects&.count
      end

      def results
        @objects = @result
        @all = total
        all_datas
      end

      def all_datas
        check_limit_and_offset
        {
          message: t('officer.success'), total: @all,
          limit: params[:limit], offset: params[:offset],
          data: serializer(desc(@objects))
        }
      end

      def check_limit_and_offset
        limit if params[:limit].present?
        offset if params[:offset].present?
      end

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
