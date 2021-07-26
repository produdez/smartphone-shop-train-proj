# frozen_string_literal: true

FactoryBot.define do
  factory :operating_system do
    name { Faker::Name.unique.name }
  end
end
