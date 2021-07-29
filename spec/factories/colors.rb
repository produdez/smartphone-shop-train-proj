# frozen_string_literal: true

FactoryBot.define do
  factory :color do
    name { Faker::Name.unique.name }
  end
end
