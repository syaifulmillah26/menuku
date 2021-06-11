# frozen_string_literal: true

module StateMachines
  # state machines
  module Payment
    extend ActiveSupport::Concern
    included do
      state_machine :status, initial: :pending do
        event :paid do
          transition to: :paid, from: %i[pending not_set]
        end

        event :void do
          transition to: :void, from: %i[paid not_set]
        end

        event :refund do
          transition to: :refund, from: %i[paid not_set]
        end

        # after_transition to: :confirmed, do: :update_confirmed_at
      end
    end
  end
end
