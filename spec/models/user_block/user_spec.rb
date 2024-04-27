require 'rails_helper'

RSpec.describe UserBlock::User, type: :model do
  
  it { should have_many(:properties).class_name("PropertyBlock::Property")}
  it { should have_many(:bookings).class_name("BookingBlock::Booking")}
  it { should validate_presence_of(:email)}
  it { should validate_uniqueness_of(:email)}
  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:location)}
  it { should validate_presence_of(:password)}

  describe "Association" do 
    it "checking association" do 
      association = UserBlock::User.ransackable_associations
      expect(association).to contain_exactly("properties","bookings","refund_amounts")
    end
  end

  describe "Attribute" do 
    it "checking attributes" do  
      attributes = UserBlock::User.ransackable_attributes
      expect(attributes).to contain_exactly("created_at", "email", "id", "location", "name", "password_digest", "updated_at")
    end
  end


end
