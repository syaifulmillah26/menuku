class CreateUserDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :user_details do |t|
      t.belongs_to :user
      t.integer :address_id
      t.string :fullname

      t.timestamps
    end
  end
end
