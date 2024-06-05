module UserBlock
	class User < ApplicationRecord
		self.table_name = :user_block_users

		has_many :properties, class_name:"PropertyBlock::Property"
		has_many :bookings, class_name: "BookingBlock::Booking"
		has_many :refund_amounts, class_name: "AmountBlock::RefundAmount"
		has_many :addresses
		has_secure_password
		validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
		validates :name, presence: true
		validates :location, presence: true
		validates :password, presence: true, length: { in: 6..14 }
		accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true

		def self.ransackable_associations(auth_object = nil)
    		["bookings", "properties", "refund_amounts","addresses"]
  		end

	  	def self.ransackable_attributes(auth_object = nil)
    		["created_at", "email", "id", "location", "name", "password_digest", "stripe_cust_id", "updated_at"]
  		end


	    def self.from_omniauth(auth)
		   user = find_by(email: auth.info.email || fetch_email(auth.credentials.token))
		   user
	    end

  	private

	  def self.fetch_email(token)
	    response = HTTParty.get(ENV['HOST_URL'],
	                            headers: { 'Authorization' => "token #{token}" })
	    json = JSON.parse(response.body)
	    json.first['email'] if response.code == 200 && !json.empty?
	  end

	end
end
