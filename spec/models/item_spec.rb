require 'rails_helper'

RSpec.describe Item, type: :model do

  describe "validations" do  
    it { should validate_presence_of :name}
    it { should validate_presence_of :description}
    it { should validate_presence_of :unit_price}
  end
  
  describe 'relationships' do 
    it { should have_many :invoice_items}
    it { should have_many(:invoices).through(:invoice_items) }
  end 

    it "can filter items by name" do
      merchant = Merchant.create(name: "MonsterShop")
      item1_params = {name: "desk", description: "cool", unit_price: "12", merchant_id: merchant.id}
      item1 = Item.create(item1_params)
      item2_params = {name: "door", description: "long", unit_price: "150", merchant_id: merchant.id}
      item2 = Item.create(item2_params)
      item3_params = {name: "modern desk", description: "very stylish and functional", unit_price: "200", merchant_id: merchant.id}
      item3 = Item.create(item3_params)
      expect(Item.filter_by_name('desk')).to eq([item1, item3])
    end

    it "can filter items by description" do
      merchant = Merchant.create(name: "MonsterShop")
      item1_params = {name: "desk", description: "cool", unit_price: "12", merchant_id: merchant.id}
      item1 = Item.create(item1_params)
      item2_params = {name: "door", description: "long", unit_price: "150", merchant_id: merchant.id}
      item2 = Item.create(item2_params)
      item3_params = {name: "modern desk", description: "very stylish and functional", unit_price: "200", merchant_id: merchant.id}
      item3 = Item.create(item3_params)
      expect(Item.filter_by_description('on')).to eq([item2, item3])
    end

    it "can filter items by unit_price" do
      merchant = Merchant.create(name: "MonsterShop")
      item1_params = {name: "desk", description: "cool", unit_price: 12, merchant_id: merchant.id}
      item1 = Item.create(item1_params)
      item2_params = {name: "door", description: "long", unit_price: 150, merchant_id: merchant.id}
      item2 = Item.create(item2_params)
      item3_params = {name: "modern desk", description: "very stylish and functional", unit_price: 200, merchant_id: merchant.id}
      item3 = Item.create(item3_params)
      expect(Item.filter_by_unit_price(200)).to eq([item3])
    end

    it "can filter items by created_at / updated_at" do
      merchant = Merchant.create(name: "MonsterShop")
      item1_params = {name: "desk", description: "cool", unit_price: 12, merchant_id: merchant.id, created_at: "2020-03-22 18:01:38 UTC", updated_at: "2020-03-23 19:01:38 UTC"}
      item1 = Item.create(item1_params)
      item2_params = {name: "door", description: "long", unit_price: 150, merchant_id: merchant.id, created_at: "2020-03-23 18:01:38 UTC", updated_at: "2020-03-24 19:01:38 UTC"}
      item2 = Item.create(item2_params)
      item3_params = {name: "modern desk", description: "very stylish and functional", unit_price: 200, merchant_id: merchant.id, created_at: "2020-03-25 18:01:38 UTC", updated_at: "2020-03-26 19:01:38 UTC"}
      item3 = Item.create(item3_params)
      expect(Item.filter_by_created_at("2020-03-23 18:01:38 UTC")).to eq([item2])
      expect(Item.filter_by_created_at("18:01:38 UTC")).to eq([])
    end
end


