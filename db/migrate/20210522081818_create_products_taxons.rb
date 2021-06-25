class CreateProductsTaxons < ActiveRecord::Migration[6.1]
  def change
    create_table :products_taxons do |t|
      t.integer :product_id
      t.integer :taxon_id
      t.integer :outlet_id
      t.integer :position

      t.timestamps

      t.index [:position], name: 'index_products_taxons_on_position'
      t.index [:product_id], name: 'index_products_taxons_on_product_id'
      t.index [:taxon_id], name: 'index_products_taxons_on_taxon_id'
    end
  end
end
