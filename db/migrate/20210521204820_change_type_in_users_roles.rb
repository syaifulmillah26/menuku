class ChangeTypeInUsersRoles < ActiveRecord::Migration[6.1]
  def change
    change_column :users_roles, :user_id, :string
  end
end
