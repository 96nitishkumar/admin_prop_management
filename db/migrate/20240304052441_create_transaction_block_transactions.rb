class CreateTransactionBlockTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_block_transactions do |t|
      t.bigint :booking_id
      t.decimal :amount
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
