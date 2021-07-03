# frozen_string_literal: true

module StateMachines
  # state machines
  module Payment
    extend ActiveSupport::Concern
    included do
      state_machine :status, initial: :pending do
        event :paid do
          transition to: :paid, from: %i[pending paid not_set]
        end

        event :void do
          transition to: :void, from: %i[paid void not_set]
        end

        event :refund do
          transition to: :refund, from: %i[paid void refund not_set]
        end

        before_transition to: :paid, do: :ensure_transition_allowed_paid
        after_transition to: :paid, do: :update_order_payment_status
      end

      def ensure_transition_allowed_paid
        raise 'Payment is already paid' if paid?
      end

      def update_order_payment_status
        order.update_column(:payment_status, 'completed')
        order.update_column(:payment_total, amount)
      end
    end
  end
end
