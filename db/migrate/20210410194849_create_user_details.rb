class CreateUserDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :user_details do |t|
      t.integer :user_id
      t.integer :address_id
      t.string :fullname

      t.timestamps
    end
  end
end
