FactoryBot.define do
  factory :item do
    name { "book" }
    description { "very interesting" }
    unit_price { 1.5 }
    merchant { nil }
  end
end
