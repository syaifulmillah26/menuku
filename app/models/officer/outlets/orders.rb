# frozen_string_literal: true

module Officer
  module Outlets
    # Orders
    class Orders < Main
      # grab all orders
      def grab_all
        return false, { message: t('officer.invalid_params') } if \
          params[:outlet_id].blank?

        [true, orders]
      rescue StandardError => e
        [false, { message: "Error while grab all orders err: #{e}" }]
      end

      # grab one
      def grab_one
        return false, { message: t('officer.invalid_params') } if \
          params[:id].blank?

        [true, results]
      rescue StandardError => e
        [false, { message: "Error while grab order err: #{e}" }]
      end

      def create
        return false, { message: t('officer.invalid_params') } if \
          params[:order].blank?

        return false, { message: 'Table is booked' } if \
          table_is_booked

        [true, order_created]
      rescue StandardError => e
        [false, { message: "Error while grab order err: #{e}" }]
      end

      # update order
      def update_order
        return false, { message: t('officer.invalid_params') } if \
          params[:order].blank?

        order.update(order_params)
        [true, results]
      rescue StandardError => e
        [false, { message: "Error while updating order err: #{e}" }]
      end

      # confirm
      def confirm
        return false, { message: t('officer.invalid_params') } if \
          params[:id].blank?

        order.confirm!
        [true, results]
      rescue StandardError => e
        [false, { message: e.message }]
      end

      # done
      def done
        return false, { message: t('officer.invalid_params') } if \
          params[:id].blank?

        order.done!
        [true, results]
      rescue StandardError => e
        [false, { message: e.message }]
      end

      private

      def orders
        ::Order.where(outlet_id: outlet_id)
      end

      def order
        Order.find(params[:id])
      end

      def table_is_booked
        Table.find(params[:order][:table_id])
      end

      def order_created
        order = Order.new(order_params)
        order.save!
        {
          message: 'success',
          data: order.as_json.merge(
            items: order&.items
          )
        }
      end

      def results
        {
          message: 'success',
          data: order.as_json.merge(
            items: order&.items
          )
        }
      end

      def order_params
        params[:order].permit(permitted_params)
      end

      def permitted_params
        ::Officer::PermittedAttributes.order_attributes
      end
    end
  end
end
