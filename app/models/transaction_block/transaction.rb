module TransactionBlock
	class Transaction < ApplicationRecord
		self.table_name = :transaction_block_transactions
		has_many :refund_amounts, class_name: "AmountBlock::RefundAmount"
		belongs_to :booking, class_name: "BookingBlock::Booking"

		validates :amount, presence: true

		enum status: ["pending","paid", "unpaid"]
		after_update :remove_pending_transaction

		def self.ransackable_associations(auth_object = nil)
    	["booking"]
  	end

  	def self.ransackable_attributes(auth_object = nil)
    	["amount", "booking_id", "created_at", "id", "status", "updated_at"]
  	end

  	private 

  	def remove_pending_transaction
  		transaction = booking.transactions.where(status:"pending")
  		if transaction
  			transaction.delete_all
  		end
  	end


	end
end
