class AmountBlock::RefundAmount < ApplicationRecord
	self.table_name = :amount_block_refund_amounts

	belongs_to :user, class_name: "UserBlock::User"
	belongs_to :transac, class_name: "TransactionBlock::Transaction", foreign_key: "transaction_id"

	def self.ransackable_associations(auth_object = nil)
    	["user", "transac", ""]
  end

  	def self.ransackable_attributes(auth_object = nil)
    	["created_at", "refund_amount", "id", "user_id", "transaction_id", "updated_at"]
  	end

end
