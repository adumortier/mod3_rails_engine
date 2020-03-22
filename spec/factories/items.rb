FactoryBot.define do
  factory :item do
    name { "book" }
    description { "very interesting" }
    unit_price { 1.5 }
    merchant { nil }
  end
  
  factory :random_item, class: Item do
    name { Faker::Commerce.product_name }
    description { Faker::Restaurant.description }
    unit_price { Faker::Commerce.price }
    association :merchant
  end
  # 
end
