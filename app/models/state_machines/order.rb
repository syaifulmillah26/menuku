# frozen_string_literal: true

module StateMachines
  # state machines
  module Order
    extend ActiveSupport::Concern
    included do
      state_machine :status, initial: :draft do
        event :confirm do
          transition to: :confirmed, from: %i[draft confirmed not_set]
        end

        event :done do
          transition to: :done, from: %i[draft confirmed done not_set]
        end

        before_transition to: :confirmed, do: :ensure_payment_is_empty
        after_transition to: :confirmed, do: :set_payment_status

        after_transition to: :done, do: :free_table
      end

      def free_table
        table = Table.find(object&.table_id)
        table.available!
      end

      def ensure_payment_is_empty
        return unless payment.blank?
        return do_pay_at_cashier if payment_preference == 'cashier'

        result = Veritrans.create_widget_token(
          transaction_details: {
            order_id: 'A98000',
            gross_amount: total
          }
        )
        create_payment(result)
      end

      def do_pay_at_cashier
        puts 'pay at cashier'
      end

      def create_payment(result)
        ::Payment.create!(
          order_id: id,
          amount: total,
          payment_method_id: 4,
          midtrans_response: [result.data] || ''
        )
      end

      def set_payment_status
        update_column(:payment_status, 'pending')
      end
    end
  end
end
