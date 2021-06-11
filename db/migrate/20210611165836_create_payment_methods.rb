class CreatePaymentMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_methods do |t|
      t.string :type
      t.string :name
      t.text :description
      t.boolean :active, default: true
      t.datetime :deleted_at
      t.string :display_on
      t.boolean :auto_capture
      t.text :preferences
      t.string :preference_source
      t.integer :position, default: 0
      t.index [:id, :type], name: 'index_spree_payment_methods_on_id_and_type'

      t.timestamps
    end
  end
end
