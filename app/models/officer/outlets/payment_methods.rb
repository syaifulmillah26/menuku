# frozen_string_literal: true

module Officer
  module Outlets
    # Main
    class PaymentMethods < Main
      # grab all payment methods outlets
      def grab_all
        [200, results(payment_methods)]
      end

      private

      def payment_methods
        ::PaymentMethod.all
      end
    end
  end
end
