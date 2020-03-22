FactoryBot.define do
  factory :merchant do
    name { "The coolest merchant" }
  end

  factory :random_merchant, class: Merchant do
    name { Faker::Company.name }
  end
end
