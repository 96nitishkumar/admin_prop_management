require 'rails_helper'

RSpec.describe TransactionBlock::TransactionsController, type: :controller do
  let(:user) { UserBlock::User.create(name:"nitish singh", email: "singh@gmail.com", password:"123456", location:"hyderabad", stripe_cust_id:"cus_PiT8Tqb5wqzVvg")}
  let(:user_1) { UserBlock::User.create(name:"singh", email: "singh1@gmail.com", password:"123456", location:"hyderabad")}
  let(:property) { PropertyBlock::Property.create(property_name:"extended_property", cost_per_day: 50000, no_of_days: 6, status:1, user_id:user.id, location: "hitech", cost_per_day:100)}
  let(:booking) { BookingBlock::Booking.create(from_date: Date.today + 10.days, to_date: Date.today + 12.days, property_id: property.id, user_id:user.id)}
  let(:booking_1) { BookingBlock::Booking.create(from_date: Date.today, to_date: Date.today + 2.days, property_id: property.id, user_id:user_1.id, status: "accept")}
  let(:transaction) { TransactionBlock::Transaction.create(booking_id: booking.id, amount: booking.total_price)}
  let(:token_1) { JwtToken.encode_token(user_1.id)}
  let(:token) { JwtToken.encode_token(user.id)}


  describe "POST /create" do

    it "returen the response ok" do 
      request.headers['token'] = token
      post :create, params: {booking_id: booking.id, amount: booking.total_price, "card_id":"card_1Ot2KhSDxIyHag1HVM72qn2r"}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["messages"]).to eq("Your transaction is completed")
    end

    it "returen the response status 422" do 
      request.headers['token'] = token
      post :create, params: {booking_id: booking.id}
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["errors"]).to eq("Your amount must be equal to booking amount")
    end
  
  end

  describe "GET /index" do
    it "checking the response ok" do 
      request.headers['token'] = token_1
      get :index
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["messages"]).to eq("Your trasaction list")

    end
  
  end

  describe "GET /show" do

    it "checking the response ok" do 
      transaction = TransactionBlock::Transaction.create(booking_id: booking.id, amount: booking.total_price)
      request.headers['token'] = token
      get :show, params: { transaction_id: transaction.id}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["messages"]).to eq("Your transaction data")

    end 

    it "checking the response status 401" do 
      transaction = TransactionBlock::Transaction.create(booking_id: booking.id, amount: booking.total_price)
      request.headers['token'] = token_1
      get :show, params: { transaction_id: transaction.id}
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)["errors"]).to eq("Your not authorized to see this transaction")

    end 
  
  end
end
