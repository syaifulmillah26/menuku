class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.string :outlet_id, null: false
      t.integer :product_id
      t.integer :order_id
      t.integer :quantity, default: 1
      t.integer :is_cancel, default: false

      t.timestamps
    end
  end
end
