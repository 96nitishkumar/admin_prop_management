require 'rails_helper'

RSpec.describe AmountBlock::RefundAmount, type: :model do
  
  it { should belong_to(:user).class_name("UserBlock::User") }
  it { should belong_to(:transac).class_name("TransactionBlock::Transaction")}

  describe "ransackable_attributes" do
    it "returns the expected attributes" do
      auth_object = double("auth_object")
      ransackable_attributes = AmountBlock::RefundAmount.ransackable_attributes(auth_object)
      
      expect(ransackable_attributes).to include("created_at", "refund_amount", "id", "user_id", "transaction_id", "updated_at")
    end
  end

  describe "ransackable_association" do
    it "returns the expected association user" do
      ransackable_association = AmountBlock::RefundAmount.ransackable_associations
      expect(ransackable_association).to include('user')
    end

    it "returns the expected association Transaction" do
      ransackable_association = AmountBlock::RefundAmount.ransackable_associations
      expect(ransackable_association).to include('transac')
    end
  end
end