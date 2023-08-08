FactoryBot.define do
  factory :mycelium do
    name { "Prefix-#{Faker::Number.number(digits: 4)}" }
    type { "Culture" }
    species { "agaricus_bisporus" }
    inoculation_date { Time.now }
    generation { 1 }
    prefix { "Prefix-#{Faker::Number.number(digits: 4)}" }
    substrate { Mycelium.substrates.keys.sample }
    container { Mycelium.containers.keys.sample }
    weight { Faker::Number.decimal(l_digits: 2) }
    shelf_time { Faker::Number.number(digits: 2) }
    image_url { Faker::Internet.url }
    strain_source_id { nil }

    association :organization
    # TODO: Set up :strain_source association without an infinite loop
    # association :strain_source, factory: :mycelium, strategy: :build, optional: true
  end
end
