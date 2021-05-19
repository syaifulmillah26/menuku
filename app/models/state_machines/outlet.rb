# frozen_string_literal: true

module StateMachines
  # state machines
  module Outlet
    extend ActiveSupport::Concern
    included do
      state_machine :status, initial: :inactive do
        event :active do
          transition to: :active, from: %i[inactive not_set]
        end

        after_transition to: :active, do: :generate_uuid
      end
    end
  end
end
