# frozen_string_literal: true

module Officer
  module Account
    # email confirmation
    class Profile < ::Api::ApplicationController
      include UserHelper
      attr_reader :params, :current_user

      def initialize(params, current_user)
        @params = params
        @current_user = current_user
      end

      def update_user_detail
        begin
          user_detail.update(user_detail_param)
          data = { message: t('officer.account.success'), data: serializer(current_user) }
          return true, data
        rescue StandardError => e
          return false, e.message
        end
      end

      def user_detail
        current_user.user_detail
      end

      private

      def user_detail_param
        params[:user_detail].permit(permitted_params)
      end

      def permitted_params
        ::Officer::PermittedAttributes.user_detail_attributes
      end
    end
  end
end
