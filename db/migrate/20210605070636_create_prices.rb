# frozen_string_literal: true

class CreatePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :prices do |t|
      t.integer :product_id, null: false
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :cost_price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
