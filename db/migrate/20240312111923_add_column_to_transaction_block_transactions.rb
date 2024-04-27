class AddColumnToTransactionBlockTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transaction_block_transactions, :card_id, :string
  end
end
