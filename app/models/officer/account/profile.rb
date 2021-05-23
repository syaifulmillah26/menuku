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

      # update user detail
      def update_user_detail
        return false, { message: t('officer.account.success') } \
          unless update_user_detail_params

        user_detail.update(user_detail_param)

        [true, { message: t('officer.account.success'), data: serializer(current_user) }]
      rescue StandardError => e
        [false, e.message]
      end

      private

      def user_detail
        current_user.user_detail
      end

      def update_user_detail_params
        return false if params[:user_detail].blank?

        true
      end

      def user_detail_param
        params[:user_detail].permit(permitted_params)
      end

      def permitted_params
        ::Officer::PermittedAttributes.user_detail_attributes
      end
    end
  end
end
