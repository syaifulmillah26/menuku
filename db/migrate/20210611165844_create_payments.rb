class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.decimal :amount, precision: 10, scale: 2, default: '0.0', null: false
      t.integer :order_id
      t.string :source_type
      t.integer :source_id
      t.integer :payment_method_id
      t.string :state
      t.string :response_code
      t.string :avs_response
      t.string :number
      t.string :cvv_response_code
      t.string :cvv_response_message
      t.string :midtrans_trnsaction_id
      t.string :midtrans_transaction_status
      t.index [:order_id], name: 'index_spree_payments_on_order_id'
      t.index [:payment_method_id], name: 'index_spree_payments_on_payment_method_id'
      t.index [:source_id, :source_type], name: 'index_spree_payments_on_source_id_and_source_type'
      t.timestamps
    end
  end
end
