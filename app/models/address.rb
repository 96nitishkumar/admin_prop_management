class Address < ApplicationRecord

	belongs_to :user, class_name: "UserBlock::User"
	validates :full_address, presence: true

	geocoded_by :full_address
	after_validation :geocode, if: ->(obj){ obj.full_address.present? and obj.full_address_changed? }

	  
	after_validation :reverse_geocode, if: ->(obj){ obj.latitude.present? and obj.longitude.present? and (obj.latitude_changed? or obj.longitude_changed?) }
	reverse_geocoded_by :latitude, :longitude do |obj, results|
	  obj.full_address = results.first.data["display_name"] 
	end

  	def reverse_geocode_in_language(lang)
    	results = Geocoder.search([latitude, longitude], language: lang)
    	self.full_address = results.first.data["display_name"]
  	end

  	def self.ransackable_attributes(auth_object = nil)
    	["full_address", "latitude", "created_at", "id", "longitude","user_id", "updated_at"]
  	end

end
