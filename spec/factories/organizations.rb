# spec/factories/organizations.rb
FactoryBot.define do
  sequence(:unique_name) { |n| "My Organization #{n}" }

  factory :organization do
    name { generate(:unique_name) }
  end
end
