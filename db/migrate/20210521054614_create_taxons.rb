class CreateTaxons < ActiveRecord::Migration[6.1]
  def change
    create_table :taxons do |t|
      t.integer :parent_id
      t.integer :position, default: 0
      t.string :name, null: false
      t.string :permalink
      t.integer :taxonomy_id
      t.integer :lft
      t.integer :rgt
      t.string :icon_file_name
      t.string :icon_content_type
      t.integer :icon_file_size
      t.datetime :icon_updated_at
      t.text :description
      t.string :meta_title
      t.string :meta_description
      t.string :meta_keywords
      t.integer :depth
      t.string :slug

      t.timestamps

      t.index [:parent_id], name: 'index_taxons_on_parent_id'
      t.index [:permalink], name: 'index_taxons_on_permalink'
      t.index [:position], name: 'index_taxons_on_position'
      t.index [:taxonomy_id], name: 'index_taxons_on_taxonomy_id'
    end
    add_index :taxons, :slug, unique: true
  end
end
