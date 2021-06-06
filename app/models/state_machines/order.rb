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

        after_transition to: :done, do: :free_table
      end
    end
  end
end
