class RemoveColumnRoleFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :user_block_users, :role, :integer
  end
end
