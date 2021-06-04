class AddAncestryToTaxons < ActiveRecord::Migration[6.1]
  def change
    add_column :taxons, :ancestry, :string
    add_index :taxons, :ancestry
  end
end
