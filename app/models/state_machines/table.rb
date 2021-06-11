# frozen_string_literal: true

module StateMachines
  # state machines
  module Table
    extend ActiveSupport::Concern
    included do
      state_machine :status, initial: :available do
        event :booked do
          transition to: :booked, from: %i[available booked not_set]
        end

        event :available do
          transition to: :available, from: %i[available booked not_set]
        end

        after_transition to: :booked, do: :set_guest_access
        after_transition to: :available, do: :remove_guest_access
      end

      def set_guest_access
        update_column(:guest_access, set_number)
      end

      def remove_guest_access
        update_column(:guest_access, nil)
      end
    end
  end
end
