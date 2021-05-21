class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.integer :outlet_id
      t.string :name
      t.string :description
      t.integer :promotionable
      t.string :slug

      t.timestamps
    end
    add_index :products, :slug, unique: true
  end
end
