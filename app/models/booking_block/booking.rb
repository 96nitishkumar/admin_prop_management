module BookingBlock
	class Booking < ApplicationRecord
		self.table_name = :booking_block_bookings
		has_many :transactions, class_name: "TransactionBlock::Transaction"
		belongs_to :user, class_name: "UserBlock::User"
		belongs_to :property, class_name: "PropertyBlock::Property"

		validates :from_date, presence: true
		validates :to_date, presence: true
		validates_numericality_of :total_price, presence: true
		validate :check_date, on: :create
		before_create :set_amount
		after_update :refund_amount, if:-> {self.status == 'rejected' || self.status == 'canceled'}

		enum status: ["pending","accept","rejected", "canceled"]

		def self.ransackable_associations(auth_object = nil)
    	["transactions", "property", "user"]
  	end

  	def self.ransackable_attributes(auth_object = nil)
    	["created_at", "from_date", "id", "property_id", "status", "to_date", "total_price", "updated_at", "user_id","card_id"]
  	end
		

		def set_amount
			self.total_price = property.cost_per_day * @total_days
		end

		def check_date
			@total_days = (to_date - from_date)/1.day
		  if from_date < Date.today
		    errors.add(:base, "From date cannot be in the past")
		  elsif to_date <= from_date
		    errors.add(:base, "To date must be after from date")
		  elsif property.no_of_days < @total_days
 			errors.add(:base, "you can't book this property for #{@total_days} days, you can book less or equal to #{property.no_of_days} days")
		  elsif property.bookings.where.not(status:"rejected").exists?(['(from_date, to_date) OVERLAPS (?, ?)', from_date, to_date])
		    errors.add(:base, "This property is not available for the selected dates")
		  end
		end


  	def refund_amount
		  transactions = TransactionBlock::Transaction.where(booking_id: self.id)
		  if transactions.present? && Time.now.utc < from_date
		    refund_percentage = Time.now.utc < (self.from_date - 24.hours) ? 1.0 : 0.80
		    calculate_refund_amount(transactions.last, refund_percentage)
		  end
		end

		private

		def calculate_refund_amount(transaction, refund_percentage)
		  refund_amount = transaction.amount * refund_percentage
		  AmountBlock::RefundAmount.create(transaction_id: transaction.id, refund_amount: refund_amount, user_id: self.user_id)
		end

	end
end

