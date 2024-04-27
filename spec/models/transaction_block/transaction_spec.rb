require 'rails_helper'

RSpec.describe TransactionBlock::Transaction, type: :model do
  it { should belong_to(:booking).class_name("BookingBlock::Booking")}
  it { should validate_presence_of(:amount)}

  describe "Enums" do
    it { should define_enum_for(:status).with_values(["completed", "canceled"]) }
  end

  describe "ransackable_associations" do 

    it "checking association with booking" do 
     ransacable_association = TransactionBlock::Transaction.ransackable_associations
     expect(ransacable_association).to contain_exactly("booking")
    end

  end

  describe "ransackable_attributes" do 

    it "checking attribute with booking" do 
     ransackable_attributes = TransactionBlock::Transaction.ransackable_attributes
     expect(ransackable_attributes).to contain_exactly("amount", "booking_id", "created_at", "id", "status", "updated_at")
    end

  end
end
