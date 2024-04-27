require 'rails_helper'

RSpec.describe AdminUser, type: :model do
 describe "Attribute" do 
    it "checking attributes" do  
      attributes = AdminUser.ransackable_attributes
      expect(attributes).to contain_exactly("created_at", "email", "encrypted_password", "id", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at")
    end
  end
end
