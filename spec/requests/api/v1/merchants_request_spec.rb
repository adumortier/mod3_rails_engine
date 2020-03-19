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
    
end