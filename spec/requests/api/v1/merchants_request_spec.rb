require 'rails_helper'

describe "Merchants API" do
  
  it "sends a list of merchants" do 
    create_list(:merchant, 4)
    
    get "/api/v1/merchants"
    expect(response).to be_successful
    merchants = JSON.parse(response.body)
    expect(merchants["data"].count).to eq(4)
  end

  it "sends an individual merchant" do
    id = create(:merchant).id
    get "/api/v1/merchants/#{id}"
    expect(response).to be_successful
    merchant = JSON.parse(response.body)
    expect(merchant["data"]["id"]).to eq(id.to_s)
  end

  it "creates a new merchant" do
    create_list(:merchant, 4)
    merchant_params = {name: "best merchant"}
    post "/api/v1/merchants", params: {merchant: merchant_params}
    expect(response).to be_successful
    merchant = Merchant.last
    expect(merchant.name).to eq(merchant_params[:name])
  end

  it "updates a merchant" do
    create_list(:merchant, 4)
    id = create(:merchant).id
    previous_name = Merchant.last.name
    new_merchant_params = {name: "cooler merchant"}
    patch "/api/v1/merchants/#{id}", params: {merchant: new_merchant_params}
    expect(response).to be_successful
    merchant = Merchant.find(id)
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq("cooler merchant")
  end

  it "deletes a merchant" do
    create_list(:merchant, 4)
    merchant = create(:merchant)
    delete "/api/v1/merchants/#{merchant.id}"
    expect(response).to be_successful
    expect(Merchant.all.count).to eq(4)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "sends the items of a merchant" do
    create_list(:merchant, 4)
    merchant1 = Merchant.first
    create_list(:item, 4, merchant: merchant1)
    merchant2 = Merchant.last
    create_list(:item, 2, merchant: merchant2)
    get "/api/v1/merchants/#{merchant1.id}/items"
    expect(response).to be_successful 
    items_merchant1 = JSON.parse(response.body)["data"]
    expect(items_merchant1.count).to eq(4)
    get "/api/v1/merchants/#{merchant2.id}/items"
    items_merchant2 = JSON.parse(response.body)["data"]
    expect(items_merchant2.count).to eq(2)
  end

  it "finds a merchant from a query string" do 
    merchant2 = Merchant.create(name: "Telerama")
    merchant3 = Merchant.create(name: "Turing")
    merchant4 = Merchant.create(name: "AskForIt")
    merchant5 = Merchant.create(name: "CoolBiz")
    merchant1 = Merchant.create(name: "Ring World")
    get "/api/v1/merchants/find?name=ring&created_at=#{merchant3.created_at.to_s}" 
    expect(response).to be_successful
    merchant = JSON.parse(response.body)["data"]
    expect(merchant["attributes"]["name"]).to eq("Turing")
    expect(merchant["id"]).to eq(merchant3.id.to_s)
  end

  it "returns all merchants matching a query" do
    merchant2 = Merchant.create(name: "Telerama")
    merchant3 = Merchant.create(name: "Turing")
    merchant4 = Merchant.create(name: "AskForIt")
    merchant5 = Merchant.create(name: "CoolBiz")
    merchant1 = Merchant.create(name: "Ring World")
    get "/api/v1/merchants/find_all?name=ring" 
    expect(response).to be_successful
    merchants = JSON.parse(response.body)["data"]
    expect(merchants.count).to eq(2)
    expect(merchants[0]["id"]).to eq(merchant1.id.to_s)
    expect(merchants[1]["id"]).to eq(merchant3.id.to_s)
    get "/api/v1/merchants/find_all?name=not_a_real_name" 
    expect(response).to be_successful
    merchants = JSON.parse(response.body)["data"]
    expect(merchants.count).to eq(0)
  end

  it "returns the merchant(s) with the most revenues" do

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

    get "/api/v1/merchants/most_revenue?quantity=2"
    expect(response).to be_successful
    returned_merchants = JSON.parse(response.body)["data"]
    expect(returned_merchants[0]["id"]).to eq(merchants[3].id.to_s)
    expect(returned_merchants[1]["id"]).to eq(merchants[4].id.to_s)
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

    get "/api/v1/merchants/most_items?quantity=2"
    expect(response).to be_successful
    returned_merchants = JSON.parse(response.body)["data"]
    expect(returned_merchants[0]["id"]).to eq(merchants[3].id.to_s)
    expect(returned_merchants[1]["id"]).to eq(merchants[1].id.to_s)
  end   

  it "returns the revenue across date range" do

    num_customer = 5
    num_merchant = 5

    customers = create_list(:random_customer, num_customer)
    merchants = create_list(:random_merchant, num_merchant)

    create_list(:random_item, 1, unit_price: 10, merchant: merchants[0])
    create_list(:random_item, 1, unit_price: 5, merchant: merchants[1])
    create_list(:random_item, 1, unit_price: 15, merchant: merchants[2])
    create_list(:random_item, 1, unit_price: 25, merchant: merchants[3])
    create_list(:random_item, 1, unit_price: 20, merchant: merchants[4])

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

    get "/api/v1/revenue?start=2012-03-10&end=2012-03-17"
    expect(response).to be_successful
    result = JSON.parse(response.body)
    expect(result["data"]["attributes"]["revenue"]).to eq(15*5+30*25.0)
  end   

  it "returns the revenue for a merchant" do

    merchant = create(:random_merchant)
    get "/api/v1/merchants/#{merchant.id}/revenue"
    expect(response).to be_successful
  end



    
end