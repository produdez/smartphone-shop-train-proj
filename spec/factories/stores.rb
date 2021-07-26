# frozen_string_literal: true

FactoryBot.define do
  factory :store do
    name { Faker::Company.unique.name }
  end
end
