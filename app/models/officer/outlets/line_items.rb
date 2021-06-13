# frozen_string_literal: true

module Officer
  module Outlets
    # Line Items
    class LineItems < Main
      # add item
      def add
        return false, { message: t('officer.invalid_params') } if \
          params[:line_item].blank?

        save_line_item
        [true, result]
      rescue StandardError => e
        [false, { message: e.message }]
      end

      # update item
      def update
        return false, { message: t('officer.invalid_params') } if \
          params[:line_item].blank?

        line_item.update(line_item_params) if table_is_match?
        [true, line_item]
      rescue StandardError => e
        [false, { message: e.message }]
      end

      # remove item
      def remove
        return false, { message: t('officer.invalid_params') } if \
          params[:id].blank?

        line_item.destroy! if table_is_match?
        [true, { message: 'success' }]
      rescue StandardError => e
        [false, { message: e.message }]
      end

      private

      def line_item
        ::LineItem.find_by(
          id: params[:id],
          outlet_id: outlet_id
        )
      end

      def line_items
        ::LineItem.where(
          outlet_id: outlet_id
        )
      end

      def result
        {
          message: 'success',
          data: @item
        }
      end

      def save_line_item
        ensure_order_exist

        @item = ::LineItem.create!(line_item_params)
      end

      def ensure_order_exist
        order = ::Order.find_by(
          outlet_id: outlet_id,
          table_id: params[:table_id]
        )

        return params[:line_item][:order_id] = order&.id if \
          order

        create_order
      end

      def create_order
        order = ::Order.create!(
          outlet_id: outlet_id,
          table_id: params[:table_id]
        )

        params[:line_item][:order_id] = order.id
      end

      def table_is_match?
        line_item.order.table_id == params[:table_id]
      end

      def line_item_params
        params[:line_item].permit(permitted_params)
      end

      def permitted_params
        ::Officer::PermittedAttributes.line_item_attributes
      end
    end
  end
end
