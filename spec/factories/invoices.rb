FactoryBot.define do
  factory :invoice do
    status { 0 }
    merchant { nil }
    customer { nil }
  end
end
