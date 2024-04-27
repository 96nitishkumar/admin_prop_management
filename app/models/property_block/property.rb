module PropertyBlock
	class Property < ApplicationRecord

		self.table_name = :property_block_properties

		has_many :bookings, class_name: "BookingBlock::Booking"
		belongs_to :user, class_name: "UserBlock::User"

		validates :property_name, presence: true, uniqueness: true
		validates :location, presence: true
		validates_numericality_of :cost_per_day, presence: true, greater_than: 0 

		enum status: ["pending", "accept"]

	  	def self.ransackable_attributes(auth_object = nil)
	    	["cost_per_day", "created_at", "id", "location", "property_name", "updated_at", "user_id", "status", "no_of_days"]
	  	end

	  	def self.ransackable_associations(auth_object = nil)
	    	["bookings", "properties","user"]
	  	end
	end
end
