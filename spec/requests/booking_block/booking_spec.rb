require 'rails_helper'

RSpec.describe BookingBlock::BookingsController, type: :controller do

  let(:user) { UserBlock::User.create(name:"nitish singh", email: "singh@gmail.com", password:"123456", location:"hyderabad")}
  let(:user_1) { UserBlock::User.create(name:"singh", email: "singh1@gmail.com", password:"123456", location:"hyderabad")}
  let(:property) { PropertyBlock::Property.create(property_name:"extended_property", cost_per_day: 50000, no_of_days: 6, status:1, user_id:user.id, location: "hitech")}
  let(:booking) { BookingBlock::Booking.create(from_date: Date.today + 10.days, to_date: Date.today + 12.days, property_id: property.id, user_id:user.id)}
  let(:booking_1) { BookingBlock::Booking.create(from_date: Date.today, to_date: Date.today + 2.days, property_id: property.id, user_id:user_1.id, status: "accept")}

  let(:token_1) { JwtToken.encode_token(user_1.id)}
  let(:token) { JwtToken.encode_token(user.id)}
  
  describe "POST /create" do
    it "checking response is ok" do 
      request.headers['token'] = token_1
      post :create, params: { booking:{ from_date: Date.today, to_date: Date.today + 4.days, property_id: property.id}}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq("Property is booked for you")
    end

    it "checking response is unprocessable_intity" do 
      request.headers['token'] = token_1
      post :create, params: { booking:{ from_date: Date.today, to_date: Date.today, property_id: property.id}}
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["message"]).to eq(" booking failed")
    end


    it "checking response not found ok" do 
      request.headers['token'] = token_1
      post :create, params: { booking:{ from_date: Date.today, to_date: Date.today + 4.days}}
      expect(response).to have_http_status(500)
    end
  end

  describe "GET /accept_or_reject_booking" do

    it "checking booking status ok" do
      request.headers['token'] = token
      get :accept_or_reject_booking, params: {status: "rejected", booking_id: booking.id}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq("Booking updated successfull..")
    end

    it "checking booking status ok" do
      request.headers['token'] = token
      get :accept_or_reject_booking, params: {status: "accept", booking_id: booking_1.id}
      expect(response).to have_http_status(422)
      # expect(JSON.parse(response.body)["message"]).to eq("Booking updated successfull..")
    end

    it "checking booking status ok" do
      request.headers['token'] = token_1
      get :accept_or_reject_booking, params: {status: "accept", booking_id: booking.id}
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)["errors"]).to eq("You are not authorized to perform this action")
    end

    it "checking booking status ok" do
      request.headers['token'] = token_1
      get :accept_or_reject_booking, params: {status: "pending", booking_id: booking.id}
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["errors"]).to eq("Invalid params status")
    end

  end

  describe "GET /cancel_booking" do

    it "checking cancel booking status 422 " do

      request.headers['token'] = token_1
      get :cancel_booking, params: {booking_id: booking_1.id}
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["message"]).to eq("you can not cancel the booking untill your transactions is completed")
    end

    it "checking booking status ok" do
      transaction = TransactionBlock::Transaction.create(booking_id: booking_1.id, amount: booking_1.total_price)
      request.headers['token'] = token_1
      get :cancel_booking, params: {booking_id: booking_1.id}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq("your booking is canceled successfully")
    end

     it "checking booking status ok" do
      transaction = TransactionBlock::Transaction.create(booking_id: booking_1.id, amount: booking_1.total_price, status:1)
      request.headers['token'] = token_1
      get :cancel_booking, params: {booking_id: booking_1.id}
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["message"]).to eq("you can not cancel the booking untill your transactions is completed")
    end
    
  end

  describe "GET /user_booking" do

    it "checking booking status ok " do

      request.headers['token'] = token_1
      get :user_booking
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq('Your booking data')
    end
    
  end

  describe "GET /show" do

    it "checking booking status ok " do

      request.headers['token'] = token_1
      get :show, params: {id: booking_1.id}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq('booking data')
    end
  end

  describe "GET /user_booking" do

    it "checking token not found message " do
      get :user_booking
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)["message"]).to eq("Token not found")
    end
  end

end
