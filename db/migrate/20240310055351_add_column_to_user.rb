class AddColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :user_block_users, :stripe_cust_id, :string
  end
end
