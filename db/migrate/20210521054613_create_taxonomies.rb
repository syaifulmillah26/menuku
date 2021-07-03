class CreateTaxonomies < ActiveRecord::Migration[6.1]
  def change
    create_table :taxonomies do |t|
      t.string :name, null: false
      t.integer :outlet_id
      t.integer :position, default: 0

      t.timestamps

      t.index [:position], name: 'index_taxonomies_on_position'
    end
  end
end
