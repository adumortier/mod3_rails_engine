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
    num_customer = 50
    num_merchant = 10
    num_items_per_merchant = 10
    num_invoice = 100
    customers = create_list(:random_customer, num_customer)
    merchants = create_list(:random_merchant, num_merchant)

    merchants.each do |merchant|
      create_list(:random_item, num_items_per_merchant, merchant: merchant)
    end  
    invoices = create_list(:invoice, num_invoice, merchant: merchants[rand(num_merchant)], customer: customers[rand(num_customer)])
    invoices.each do |invoice|
      5.times do
        random_item = merchants[rand(num_merchant)].items[rand(num_items_per_merchant)]
        create(:invoice_item, item: random_item, unit_price: random_item.unit_price, quantity: (rand(10)+1), invoice: invoice)
      end
      create(:random_transaction, result: rand(1), invoice: invoice)
    end
    
    
  end
    
end