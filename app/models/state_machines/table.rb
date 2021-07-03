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
          transition to: :available, from: %i[booked available not_set]
        end

        before_transition to: :booked, do: :ensure_table_is_available
        before_transition to: :available, do: :ensure_order_is_finished
        after_transition to: :booked, do: :set_guest_access
        after_transition to: :available, do: :remove_guest_access
      end

      def ensure_table_is_available
        raise 'Table is booked!' unless available?
      end

      def ensure_order_is_finished
        raise 'Order from this table has not finished, yet!' if active_order
      end

      def set_guest_access
        update_column(:guest_access, set_number)
      end

      def set_number
        number = rand(1_000_000)
        number_exist = ::Table.find_by(
          guest_access: number,
          outlet_id: outlet_id
        )

        return set_number if number_exist

        number
      end

      def remove_guest_access
        update_column(:guest_access, nil)
      end
    end
  end
end
