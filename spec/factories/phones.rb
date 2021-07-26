# frozen_string_literal: true

FactoryBot.define do
  factory :phone do
    manufacture_year { Faker::Number.number(digits: 4) }
    condition { 'old' }
    memory { Faker::Number.positive(from: 500.0, to: 5000.0) }
    price { BigDecimal(Faker::Number.positive(from: 500.0, to: 3000.0).to_s) }
    status { 'in_stock' }

    association :model
    association :color
    association :store
  end
end
