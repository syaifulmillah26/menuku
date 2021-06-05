class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :outlet_id, null: false
      t.integer :table_id, null: false
      t.string :order_number
      t.integer :item_count, default: 0
      t.decimal :item_total, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2
      t.decimal :additional_tax, precision: 10, scale: 2
      t.decimal :additional_services, precision: 10, scale: 2
      t.decimal :promo_total, precision: 10, scale: 2
      t.string :status

      t.timestamps
    end
  end
end
