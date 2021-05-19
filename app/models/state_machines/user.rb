# frozen_string_literal: true

module StateMachines
  # state machines
  module User
    extend ActiveSupport::Concern
    included do
      state_machine :status, initial: :unconfirmed do
        event :confirm do
          transition to: :confirmed, from: %i[
            unconfirmed confirmed inactive not_set
          ]
        end

        after_transition to: :confirmed, do: :update_confirmed_at
      end
    end
  end
end
