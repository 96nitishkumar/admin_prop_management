require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers

RSpec.describe Admin::AdminUsersController, type: :controller do
    render_views
    
    before do
        @admin_user = FactoryBot.create(:admin_user)
        sign_in @admin_user
        @user=FactoryBot.create(:user_block_user, email: "nitish@gmail.com")

    end


    describe "index" do 
        it "index" do
            get :index
            expect(response.status).to eq(200)
        end
    end

    describe 'index' do
        it 'should render the index page' do
          get :index
          expect(response).to render_template(:index)
        end
    end

    it 'should render the show page' do
        get :show, params: { id: @admin_user.id }
        expect(response).to render_template(:show)
    end

      it 'should render the form page' do
        post :create
        expect(response.status).to eq(200)
    end

    # describe 'GET #show' do
    # it 'displays photo if attached' do
    #   get :show, params: { id: @user1.id }
    #   expect(response.body).to include('download.jpeg')
    # end

    # it 'displays message if no photo attached' do
    #   get :show, params: { id: @user1.id }
    #   expect(response.body).to include('No image attached')
    # end
  end
# end