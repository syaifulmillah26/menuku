class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.decimal :amount, precision: 10, scale: 2, default: '0.0', null: false
      t.integer :order_id
      t.integer :payment_method_id
      t.string :status
      t.string :number
      t.string :card_number
      t.string :card_name
      t.string :card_expired
      t.string :cvv_number
      t.text :midtrans_response
      t.index [:order_id], name: 'index_payments_on_order_id'
      t.index [:payment_method_id], name: 'index_payments_on_payment_method_id'

      t.timestamps
    end
  end
end
