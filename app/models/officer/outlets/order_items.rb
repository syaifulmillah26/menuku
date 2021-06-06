# frozen_string_literal: true

module Officer
  module Outlets
    # Orders
    class OrderItems < Main
      # grab all orders
      def grab_all
        return false, { message: t('officer.invalid_params') } if \
          params[:outlet_id].blank?

        [true, order_items]
      rescue StandardError => e
        [false, e.message]
      end

      # add item
      def add
        return false, { message: t('officer.invalid_params') } if \
          params[:order_item].blank?

        save_order_item
        [true, result]
      rescue StandardError => e
        [false, { message: e.message }]
      end

      # update item
      def update
        return false, { message: t('officer.invalid_params') } if \
          params[:order_item].blank?

        update_order_item
        [true, order_item]
      rescue StandardError => e
        [false, { message: e.message }]
      end

      # remove item
      def remove
        return false, { message: t('officer.invalid_params') } if \
          params[:id].blank?

        order_item.destroy!
        [true, { message: 'success' }]
      rescue StandardError => e
        [false, { message: e.message }]
      end

      private

      def order_item
        ::OrderItem.find(params[:id])
      end

      def order_items
        ::OrderItem.where(outlet_id: outlet_id)
      end

      def result
        {
          message: 'success',
          data: @item
        }
      end

      def save_order_item
        @item = ::OrderItem.create!(order_item_params)
      end

      def update_order_item
        order_item.update(order_item_params)
      end

      def order_item_params
        params[:order_item].permit(permitted_params)
      end

      def permitted_params
        ::Officer::PermittedAttributes.order_item_attributes
      end
    end
  end
end
