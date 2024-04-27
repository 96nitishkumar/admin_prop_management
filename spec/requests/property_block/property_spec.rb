require 'rails_helper'
require 'jwt_token'
RSpec.describe PropertyBlock::PropertiesController, type: :controller do

  let(:user) { UserBlock::User.create(name:'nitish kumar', email:"nitish123@gmail.com", password:"123456", location:"hyderabad")}
  let(:user_1) { UserBlock::User.create(name:'nitish1 kumar', email:"nitish1234@gmail.com", password:"123456", location:"hyderabad1")}

  let(:property) { PropertyBlock::Property.create( property_name:"amulya property", cost_per_day:1000, location:'hyd',no_of_days:3,user_id: user.id)}
  let(:property_1) { PropertyBlock::Property.create( property_name:"amulya property", cost_per_day:1000, location:'hyd',no_of_days:3,user_id: user_1.id)}

  let(:token) { JwtToken.encode_token(user.id)}
  
  describe "POST /create" do
    it "response getting ok" do  
      request.headers["token"] = token
      post :create, params:{property:{property_name: "avinash property", cost_per_day: 1000, location: "hyderabad", no_of_days: 2}}
      expect(response).to have_http_status(200)
       expect(JSON.parse(response.body)["message"]).to eq("Property created successfully..")
    end

    it "response getting unprocessable entity" do  
      request.headers["token"] = token
      post :create, params:{property:{property_name: " ", cost_per_day: 1000, location: "hyderabad", no_of_days: 2}}
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["message"]).to eq("Property creation failed")
    end
  end

  describe "GET/owner_property"  do    
    it "resonse getting ok" do   
      request.headers['token'] = token
      get :owner_property
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq('Your property list')
    end

    it "resonse getting ok" do   
      request.headers['token'] = token
      get :index
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq('List of properties')
    end

    it "resonse getting ok" do   
      request.headers['token'] = token
      get :search_avail_property
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq('Available property')
    end
  end

  describe "GET/show" do   
    it "response getting ok" do  
      request.headers['token'] = token
      get :show, params: {id: property_1.id}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq('Property data')
    end
  end

  describe "PUT/update" do   
    it "response getting ok" do  
      request.headers['token'] = token
      put :update, params: {property_id: property.id,property:{property_name:"akash_property"}}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq("Property updated successfully")
    end

    it "response getting ok" do  
      request.headers['token'] = token
      put :update, params: {property_id: property.id,property:{property_name:""}}
      expect(response).to have_http_status(422)
      # expect(JSON.parse(response.body)["message"]).to eq("Property updated successfully")
    end
  end

  describe "DELETE/destroy" do   
    it "response getting ok" do  
      request.headers['token'] = token
      delete :destroy, params: {property_id: property.id}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq("Property deleted successfully...")
    end
  end
end
