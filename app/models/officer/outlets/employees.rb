# frozen_string_literal: true

module Officer
  module Outlets
    # Main
    class Employees < Main
      # grab all employee outlets
      def grab_all
        [true, employees]
      rescue StandardError => e
        [false, e.message]
      end

      private

      def employees
        params&.company&.outlets&.first&.employees
      end
    end
  end
end
