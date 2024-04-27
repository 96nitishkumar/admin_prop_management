require 'rails_helper'

RSpec.describe PropertyBlock::Property, type: :model do
  it { should have_many(:bookings).class_name("BookingBlock::Booking")}
  it { should belong_to(:user).class_name("UserBlock::User")}
  it { should validate_presence_of(:property_name)}
  it { should validate_uniqueness_of(:property_name)}
  it { should validate_presence_of(:location)}
  it { should validate_numericality_of(:cost_per_day)}

  describe "ranksackable association" do 
    it "check association with user" do 
      associaton = PropertyBlock::Property.ransackable_associations
      expect(associaton).to contain_exactly('properties', "bookings","user")
    end
  end

  describe "ranksackable attribute" do 
    it "checking ranksackable attribute" do 
      attributes = PropertyBlock::Property.ransackable_attributes
      expect(attributes).to contain_exactly("cost_per_day", "created_at", "id", "location", "property_name", "updated_at", "user_id", "status", "no_of_days")
    end

  end
    
end
