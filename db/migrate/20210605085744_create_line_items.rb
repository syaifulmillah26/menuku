class CreateLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :line_items do |t|
      t.string :outlet_id, null: false
      t.integer :product_id
      t.integer :order_id
      t.integer :quantity, default: 1

      t.timestamps
    end
  end
end
