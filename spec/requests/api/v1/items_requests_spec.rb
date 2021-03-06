require 'rails_helper'

describe "items API" do
  

  it "can send a list of items" do
    merchant = create(:merchant)
    create_list(:item, 4, merchant: merchant)
    get '/api/v1/items'
    expect(response).to be_successful
    items = JSON.parse(response.body)
    expect(items["data"].count).to eq(4)
  end

  it "can send a specific item" do 
    merchant = create(:merchant)
    new_item = create(:item, merchant: merchant)
    get "/api/v1/items/#{new_item.id}"
    expect(response).to be_successful
    item = JSON.parse(response.body)
    expect(item["data"]["id"]).to eq(new_item.id.to_s)
  end

  it "can create a new item" do
    merchant = create(:merchant)
    create_list(:random_item, 4, merchant: merchant)
    item_params = {name: "a desk", description: "cool", unit_price: 12, merchant_id: merchant.id}
    
    post "/api/v1/items", params: {item: item_params}
    expect(response).to be_successful
    my_item = Item.last 
    expect(my_item.name).to eq(item_params[:name])
    item = JSON.parse(response.body)['data']
    expect(item['attributes']['name']).to eq(item_params[:name])
  end

  it "updates an item" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    item_before_update = item
    item_params = {name: "a better desk", description: "cooler", unit_price: 120, merchant_id: merchant.id}
    patch "/api/v1/items/#{item.id}", params: {item: item_params}
    expect(response).to be_successful
    item_after_update = Item.find(item.id)
    expect(item_after_update.name).to eq("a better desk")
    expect(item_after_update.name).to_not eq(item_before_update.name)
  end

  it "deletes an item" do 
    merchant = create(:merchant)
    create_list(:item, 4, merchant: merchant)
    item = create(:item, merchant: merchant)
    delete "/api/v1/items/#{item.id}"
    expect(response).to be_successful
    expect(Item.all.count).to eq(4)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "sends the merchant it belongs to" do 
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    get "/api/v1/items/#{item.id}/merchant"
    expect(response).to be_successful
    merchant_info = JSON.parse(response.body)["data"]
    expect(merchant_info["id"]).to eq(merchant.id.to_s)
  end

  it "sends the first item matching a query" do 
    merchant = Merchant.create(name: "MonsterShop")
    item1_params = {name: "desk", description: "cool", unit_price: 12, merchant_id: merchant.id}
    item1 = Item.create!(item1_params)
    item2_params = {name: "door", description: "long", unit_price: 150, merchant_id: merchant.id}
    item2 = Item.create!(item2_params)
    item3_params = {name: "modern desk", description: "very stylish and functional", unit_price: 200, merchant_id: merchant.id}
    item3 = Item.create!(item3_params)
    get "/api/v1/items/find?name=desk&description=stylish" 
    expect(response).to be_successful
    item = JSON.parse(response.body)["data"]
    expect(item["attributes"]["unit_price"]).to eq(200)
    expect(item["id"]).to eq(item3.id.to_s)
  end

  it "sends all items matching a query" do 
    merchant = Merchant.create(name: "MonsterShop")
    item1_params = {name: "desk", description: "cool", unit_price: 12, merchant_id: merchant.id}
    item1 = Item.create!(item1_params)
    item2_params = {name: "door", description: "long", unit_price: 200, merchant_id: merchant.id}
    item2 = Item.create!(item2_params)
    item3_params = {name: "modern desk", description: "very stylish and functional", unit_price: 200, merchant_id: merchant.id}
    item3 = Item.create!(item3_params)
    get "/api/v1/items/find_all?name=desk" 
    expect(response).to be_successful
    items = JSON.parse(response.body)["data"]
    expect(items.count).to eq(2)
    expect(items[0]["id"]).to eq(item1.id.to_s)
    expect(items[1]["id"]).to eq(item3.id.to_s)
    get "/api/v1/items/find_all?unit_price=200"
    expect(response).to be_successful
    items = JSON.parse(response.body)["data"]
    expect(items.count).to eq(2)
    expect(items[0]["id"]).to eq(item2.id.to_s)
    expect(items[1]["id"]).to eq(item3.id.to_s)
  end
  
end
