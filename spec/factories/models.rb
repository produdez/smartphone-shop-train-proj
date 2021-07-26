# frozen_string_literal: true

FactoryBot.define do
  factory :model do
    name { Faker::Name.unique.name }
    association :brand
    association :operating_system
  end
end
