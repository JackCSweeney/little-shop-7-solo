FactoryBot.define do
  factory :invoice do
    status { 0 }
    customer { association :customer }
  end
end
