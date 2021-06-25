# frozen_string_literal: true

module Officer
  module Outlets
    # Main
    class Payments < Main
      include MidtransHelper

      def midtrans_call
        return error_message(t('officer.invalid_params')) if \
          params[:order_id].blank?

        @response = http_get(url, {})

        save_response if @response['status_code'] == '200'

        [200, result]
      end

      private

      def url
        "/#{params[:order_id]}/status"
      end

      def save_response
        payment.update_column(:midtrans_response, [@response])
        payment.paid!
      end

      def result
        {
          message: t('officer.success'),
          data: order.as_json.merge(
            tax_and_service_included: order&.tax_and_service_included,
            payment: order&.payment,
            items: order&.items
          )
        }
      end

      def order
        ::Order.find_by(number: params[:order_id])
      end

      def payment
        order.payment
      end
    end
  end
end
