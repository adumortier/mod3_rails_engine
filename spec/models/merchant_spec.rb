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
    it "returns a query from params" do
      where("name like ?", "%#{name}%")
      string_B LIKE '%string_A%'
      name like '%'
      params = {"name"=>"Telerama", "controller"=>"api/v1/merchants/search", "action"=>"show"}
      expect(Merchant.params_to_query).to eq({name: "Telerama"})
    end
  end
  
end

