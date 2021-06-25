# frozen_string_literal: true

module Officer
  module Outlets
    # Orders
    class Orders < Main
      # confirm
      def confirm
        order.confirm!
        [200, results]
      end

      # done
      def done
        order.done!
        [200, results]
      end

      private

      def order
        Order.find_by(
          id: params[:id],
          outlet_id: outlet_id
        )
      end

      def results
        {
          message: t('officer.success'),
          data: order.as_json.merge(
            tax_and_service_included: order&.tax_and_service_included,
            payment: order&.payment,
            items: order&.items
          )
        }
      end
    end
  end
end
