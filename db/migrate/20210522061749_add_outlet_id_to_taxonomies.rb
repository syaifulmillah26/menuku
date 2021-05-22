class AddOutletIdToTaxonomies < ActiveRecord::Migration[6.1]
  def change
    add_column :taxonomies, :outlet_id, :string
  end
end
