# frozen_string_literal: true

module StateMachines
  # state machines
  module Company
    extend ActiveSupport::Concern
    included do
      state_machine :status, initial: :trial do
        event :active do
          transition to: :active, from: %i[inactive active trial not_set]
        end

        # after_transition to: :confirmed, do: :update_confirmed_at
      end
    end
  end
end
