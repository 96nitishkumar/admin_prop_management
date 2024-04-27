require 'rails_helper'

RSpec.describe UserBlock::UsersController, type: :controller do
  describe "POST /sign_up" do
    it "creating new user" do  
      post :sign_up, params:{user:{name:"nitish", email:"nksingh@gmail.com", password:"123456",location:"hyderabad"}}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq("User created successfully")      
    end

    it "creating new user" do  
      post :sign_up, params:{user:{name:"nitish", email:"nksingh@gmail.com", password:' ',location:"hyderabad"}}
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["message"]).to eq("User not created")      
    end
  end


  describe "POST /sign_in" do
    before do 
      @user = FactoryBot.create(:user_block_user, email:"nksingh@gmail.com",password:"123456", name:"nitish", location:"hyderabad")
    end
    it "login existing user" do  
      post :sign_in, params:{email:"nksingh@gmail.com", password:"123456"}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq("Loggin successfully...")      
    end

    it "login user with wrong email" do  
      post :sign_in, params:{email:"nksingh1@gmail.com", password:'123456'}
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)["errors"]).to eq("User email does not register")      
    end

    it "login user with wrong password" do  
      post :sign_in, params:{email:"nksingh@gmail.com", password:'12345'}
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)["errors"]).to eq("Invalid password")      
    end
  end
end
