# frozen_string_literal: true

module StateMachines
  # state machines
  module User
    extend ActiveSupport::Concern
    included do
      state_machine :status, initial: :inactive do
        event :activate do
          transition to: :active, from: %i[
            active inactive not_set
          ]
        end

        after_transition to: :active, do: :update_confirmed_at
      end

      def update_confirmed_at
        update_column(:confirmed_at, current_time)
      end
    end
  end
end
