class CreateTables < ActiveRecord::Migration[6.1]
  def change
    create_table :tables do |t|
      t.integer :outlet_id, null: false
      t.integer :table_number
      t.integer :seat, default: 0
      t.integer :guest_access
      t.string :guest_token
      t.string :status

      t.timestamps
    end
  end
end
