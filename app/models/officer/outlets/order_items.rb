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
        ::OrderItem.where(
          outlet_id: outlet_id,
          order_id: params[:order_id]
        )
      end

      def result
        {
          message: 'success',
          data: @item
        }
      end

      def save_order_item
        ensure_order_exist

        @item = ::OrderItem.create!(order_item_params)
      end

      def ensure_order_exist
        order = ::Order.where(
          outlet_id: outlet_id,
          table_id: params[:table_id]
        )&.first

        return params[:order_item][:order_id] = order&.id if \
          order

        create_order
      end

      def create_order
        order = ::Order.create(
          outlet_id: outlet_id,
          table_id: params[:table_id]
        )

        params[:order_item][:order_id] = order.id
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
