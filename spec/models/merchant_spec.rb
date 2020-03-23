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

    it "returns a list of merchant with the most revenue" do
      num_customer = 5
      num_merchant = 5

      customers = create_list(:random_customer, num_customer)
      merchants = create_list(:random_merchant, num_merchant)

      create_list(:random_item, 2, unit_price: 10, merchant: merchants[0])
      create_list(:random_item, 2, unit_price: 5, merchant: merchants[1])
      create_list(:random_item, 2, unit_price: 15, merchant: merchants[2])
      create_list(:random_item, 2, unit_price: 25, merchant: merchants[3])
      create_list(:random_item, 2, unit_price: 20, merchant: merchants[4])

      create_list(:invoice, 2, merchant: merchants[0], customer: customers[rand(num_customer)])
      create_list(:invoice, 2, merchant: merchants[1], customer: customers[rand(num_customer)])
      create_list(:invoice, 2, merchant: merchants[2], customer: customers[rand(num_customer)])
      create_list(:invoice, 2, merchant: merchants[3], customer: customers[rand(num_customer)])
      create_list(:invoice, 2, merchant: merchants[4], customer: customers[rand(num_customer)])

      merchants.each do |merchant|
        create(:invoice_item, item: merchant.items[0], unit_price: merchant.items[0].unit_price, quantity: 2, invoice: merchant.invoices[0])
        create(:invoice_item, item: merchant.items[1], unit_price: merchant.items[1].unit_price, quantity: 2, invoice: merchant.invoices[1])
        merchant.invoices.each do |invoice|
          create(:random_transaction, result: 1, invoice: merchant.invoices[0])
          create(:random_transaction, result: 1, invoice: merchant.invoices[1])
        end
      end
      returned_merchants = Merchant.most_revenue(2)
      expect(returned_merchants.length).to eq(2)
      expect(returned_merchants[0].id).to eq(merchants[3].id)
      expect(returned_merchants[1].id).to eq(merchants[4].id)
    end

    it "returns the merchant who sell the most items" do
      num_customer = 5
      num_merchant = 5

      customers = create_list(:random_customer, num_customer)
      merchants = create_list(:random_merchant, num_merchant)

      create_list(:random_item, 1, unit_price: 10, merchant: merchants[0])
      create_list(:random_item, 1, unit_price: 5, merchant: merchants[1])
      create_list(:random_item, 1, unit_price: 15, merchant: merchants[2])
      create_list(:random_item, 1, unit_price: 25, merchant: merchants[3])
      create_list(:random_item, 1, unit_price: 20, merchant: merchants[4])

      create_list(:invoice, 2, merchant: merchants[0], customer: customers[rand(num_customer)])
      create_list(:invoice, 2, merchant: merchants[1], customer: customers[rand(num_customer)])
      create_list(:invoice, 2, merchant: merchants[2], customer: customers[rand(num_customer)])
      create_list(:invoice, 2, merchant: merchants[3], customer: customers[rand(num_customer)])
      create_list(:invoice, 2, merchant: merchants[4], customer: customers[rand(num_customer)])

      create(:invoice_item, item: merchants[0].items[0], unit_price: merchants[0].items[0].unit_price, quantity: 10, invoice: merchants[0].invoices[0])
      create(:invoice_item, item: merchants[1].items[0], unit_price: merchants[1].items[0].unit_price, quantity: 15, invoice: merchants[1].invoices[0])
      create(:invoice_item, item: merchants[2].items[0], unit_price: merchants[2].items[0].unit_price, quantity: 5, invoice: merchants[2].invoices[0])
      create(:invoice_item, item: merchants[3].items[0], unit_price: merchants[3].items[0].unit_price, quantity: 30, invoice: merchants[3].invoices[0])
      create(:invoice_item, item: merchants[4].items[0], unit_price: merchants[4].items[0].unit_price, quantity: 25, invoice: merchants[4].invoices[0])

      create(:random_transaction, result: 1, invoice: merchants[0].invoices[0])
      create(:random_transaction, result: 1, invoice: merchants[1].invoices[0])
      create(:random_transaction, result: 0, invoice: merchants[2].invoices[0])
      create(:random_transaction, result: 1, invoice: merchants[3].invoices[0])
      create(:random_transaction, result: 0, invoice: merchants[4].invoices[0])

      returned_merchants = Merchant.most_items(2)

      expect(returned_merchants.length).to eq(2)
      expect(returned_merchants[0].id).to eq(merchants[3].id)
      expect(returned_merchants[1].id).to eq(merchants[1].id)
    end   

    it "returns the revenue across a date range" do
      num_customer = 5
      num_merchant = 5

      customers = create_list(:random_customer, num_customer)
      merchants = create_list(:random_merchant, num_merchant)

      create(:random_item, unit_price: 10, merchant: merchants[0])
      create(:random_item, unit_price: 5, merchant: merchants[1])
      create(:random_item, unit_price: 15, merchant: merchants[2])
      create(:random_item, unit_price: 25, merchant: merchants[3])
      create(:random_item, unit_price: 20, merchant: merchants[4])

      create_list(:invoice, 2, merchant: merchants[0], customer: customers[rand(num_customer)], created_at: "2012-03-09")
      create_list(:invoice, 2, merchant: merchants[1], customer: customers[rand(num_customer)], created_at: "2012-03-10")
      create_list(:invoice, 2, merchant: merchants[2], customer: customers[rand(num_customer)], created_at: "2012-03-07")
      create_list(:invoice, 2, merchant: merchants[3], customer: customers[rand(num_customer)], created_at: "2012-03-15")
      create_list(:invoice, 2, merchant: merchants[4], customer: customers[rand(num_customer)], created_at: "2012-03-20")

      create(:invoice_item, item: merchants[0].items[0], unit_price: merchants[0].items[0].unit_price, quantity: 10, invoice: merchants[0].invoices[0])
      create(:invoice_item, item: merchants[1].items[0], unit_price: merchants[1].items[0].unit_price, quantity: 15, invoice: merchants[1].invoices[0])
      create(:invoice_item, item: merchants[2].items[0], unit_price: merchants[2].items[0].unit_price, quantity: 5, invoice: merchants[2].invoices[0])
      create(:invoice_item, item: merchants[3].items[0], unit_price: merchants[3].items[0].unit_price, quantity: 30, invoice: merchants[3].invoices[0])
      create(:invoice_item, item: merchants[4].items[0], unit_price: merchants[4].items[0].unit_price, quantity: 25, invoice: merchants[4].invoices[0])

      create(:random_transaction, result: 1, invoice: merchants[0].invoices[0])
      create(:random_transaction, result: 1, invoice: merchants[1].invoices[0])
      create(:random_transaction, result: 0, invoice: merchants[2].invoices[0])
      create(:random_transaction, result: 1, invoice: merchants[3].invoices[0])
      create(:random_transaction, result: 0, invoice: merchants[4].invoices[0])

      result = Merchant.total_revenue("2012-03-10", "2012-03-17")
      expect(result).to eq(15*5+30*25.0)
    end

  end
  
end

