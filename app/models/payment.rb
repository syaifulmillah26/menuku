# frozen_string_literal: true

# Payment
class Payment < ApplicationRecord
  include ApplicationHelper
  include StateMachines::Payment

  belongs_to    :payment_method,
                class_name: 'PaymentMethod'

  belongs_to    :order,
                class_name: 'Order'

  scope :refunds, -> { where(status: 'refund') }
  scope :void, -> { where(status: 'void') }

  after_create :generate_number

  private

  def generate_number
    update_column(
      :number,
      check_generated_number('MN', generated_number, 'number', 1)
    )
  end
end
