require 'rails_helper'

RSpec.describe AmountBlock::RefundAmountsController, type: :controller do
  let(:user_1) { UserBlock::User.create(name:"singh", email: "singh1@gmail.com", password:"123456", location:"hyderabad")}
  let(:token_1) { JwtToken.encode_token(user_1.id)}

  describe "GET /index" do

    it "checking response ok" do 
      request.headers['token'] = token_1
      get :index
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq("your refund list")
    end
    
  end
end
