require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe "validations" do  
    it { should validate_presence_of :name}
  end
 
  
  describe "relationships" do  
    it { should have_many :items}
    it { should have_many :invoices}
  end

  describe "methods" do
    it "can filter merchants by name" do
      merchant1 = Merchant.create(name: "Ring World")
      merchant2 = Merchant.create(name: "Teleforama")
      merchant3 = Merchant.create(name: "Turing")
      merchant4 = Merchant.create(name: "AskForIt")
      merchant5 = Merchant.create(name: "CoolBiz")
      expect(Merchant.filter_by_name('for')).to eq([merchant2, merchant4])
    end

    it "can filter merchants by created_at / updated_at" do
      merchant1 = Merchant.create(name: "Ring World", created_at: "2020-03-22 18:01:38 UTC", updated_at: "2020-03-23 19:01:38 UTC")
      merchant2 = Merchant.create(name: "Teleforama", created_at: "2020-03-24 18:01:38 UTC", updated_at: "2020-03-25 19:01:38 UTC")
      merchant3 = Merchant.create(name: "Turing", created_at: "2020-03-25 18:01:38 UTC", updated_at: "2020-03-26 19:01:38 UTC")
      merchant4 = Merchant.create(name: "AskForIt", created_at: "2020-03-26 18:01:38 UTC", updated_at: "2020-03-27 19:01:38 UTC")
      merchant5 = Merchant.create(name: "CoolBiz", created_at: "2020-03-27 18:01:38 UTC", updated_at: "2020-03-28 19:01:38 UTC")
      expect(Merchant.filter_by_created_at('2020-03-25 18:01:38 UTC')).to eq([merchant3])
      expect(Merchant.filter_by_updated_at('2020-03-25 19:01:38 UTC')).to eq([merchant2])
    end

  end
  
end

