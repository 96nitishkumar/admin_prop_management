class AddColumn1ToTransactionBlockTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transaction_block_transactions, :payment_id, :string
    add_column :transaction_block_transactions, :session_id, :string
  end
end
