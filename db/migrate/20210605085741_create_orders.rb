class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :outlet_id, null: false
      t.integer :table_id, null: false
      t.string :number
      t.integer :item_count, default: 0
      t.decimal :item_total, precision: 10, scale: 2, default: 0
      t.decimal :total, precision: 10, scale: 2, default: 0
      t.decimal :tax_and_service, precision: 10, scale: 2, default: 21
      t.decimal :total_adjustment, precision: 10, scale: 2, default: 0
      t.decimal :promo_total, precision: 10, scale: 2, default: 0
      t.string :status
      t.string :payment_preference
      t.decimal :payment_total, precision: 10, scale: 2, default: 0
      t.string :payment_status

      t.timestamps
    end
  end
end
