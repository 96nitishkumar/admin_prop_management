require 'rails_helper'

RSpec.describe BookingBlock::Booking, type: :model do
  let!(:user) { UserBlock::User.create(name:"nitish",email:"nitish@gmail.com", password:"123456",location:"hg")}
  let!(:property) { PropertyBlock::Property.create(property_name:"asd", location:"hyd", user_id:user.id,no_of_days:2, cost_per_day: 100)}

  describe "Association" do 
    it { should have_many(:transactions).class_name("TransactionBlock::Transaction")}
    it "checking association is present or not" do
      booking = BookingBlock::Booking.new(from_date:Date.today, to_date: Date.tomorrow, user_id: user.id, property_id: property.id)
      expect(booking.valid?).to eq(true)
    end
  end

  describe "Validations" do
    it "checking validation and callback" do 
      booking = BookingBlock::Booking.new(from_date:Date.today, to_date: Date.tomorrow, user_id: user.id, property_id: property.id)
      expect(booking.from_date).to eq(Date.today)
      expect(booking.to_date).to eq(Date.tomorrow)
      expect(booking.save).to eq(true)
    end
  end

  describe "Enums" do
    it { should define_enum_for(:status).with_values(["pending", "accept", "rejected", "canceled"]) }
  end



  describe "ransackable_attributes" do
    it "returns the expected attributes" do
      auth_object = double("auth_object")
      ransackable_attributes = BookingBlock::Booking.ransackable_attributes(auth_object)
      
      expect(ransackable_attributes).to include("created_at", "from_date", "id", "property_id", "status", "to_date", "total_price", "updated_at", "user_id")
    end
  end

  describe "ranksackable_association" do 
    it 'includes "property" association' do
      associations = BookingBlock::Booking.ransackable_associations
      expect(associations).to include('property')
    end

    it 'includes "user" association' do
      associations = BookingBlock::Booking.ransackable_associations
      expect(associations).to include('user')
    end
  end


  describe "Custom Validations" do
    it "checks date validity" do
      booking = BookingBlock::Booking.new(from_date:Date.today-1.day, to_date: Date.parse("01-03-2024"), user_id: user.id, property_id: property.id)
      booking.valid?
      expect(booking.errors[:base]).to include("From date cannot be in the past")
    end

    it "checks date validity" do
      booking = BookingBlock::Booking.new(from_date:Date.today, to_date: Date.today-1.day, user_id: user.id, property_id: property.id)
      booking.valid?
      expect(booking.errors[:base]).to include("To date must be after from date")
    end

    it "checks date validity" do
      booking = BookingBlock::Booking.new(from_date:Date.today, to_date: Date.today+4.day, user_id: user.id, property_id: property.id)
      booking.valid?
      expect(booking.errors[:base]).to include("you can't book this property for 4.0 days, you can book less or equal to 2 days")
    end

    let!(:booking) { BookingBlock::Booking.create(from_date: Date.today+2.day, to_date: Date.today + 3.day, property_id: property.id, user_id: user.id) }

    it "checks date validity" do
      booking = BookingBlock::Booking.new(from_date:Date.today+2.day, to_date: Date.today+ 3.day, user_id: user.id, property_id: property.id)

      booking.valid?
      expect(booking.errors[:base]).to include("This property is not available for the selected dates")
    end
  end

  describe "callback" do
    it "checking after_update callback refund_amount" do 
      property_booking = BookingBlock::Booking.create(from_date:Date.tomorrow, to_date: Date.today + 3.days, user_id: user.id, property_id: property.id)
      transaction = TransactionBlock::Transaction.create(booking_id: property_booking.id, amount: property_booking.total_price)
      update_booking = property_booking.update(status: 3)
      expect(update_booking).to eq(true) 
    end

  end
end
