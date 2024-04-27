class CreateAmountBlockRefundAmounts < ActiveRecord::Migration[7.0]
  def change
    create_table :amount_block_refund_amounts do |t|
      t.decimal :refund_amount, default: 0
      t.bigint :user_id
      t.bigint :transaction_id
      t.timestamps
    end
  end
end
