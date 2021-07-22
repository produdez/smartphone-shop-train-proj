# frozen_string_literal: true

FactoryBot.define do
  factory :model do
    sequence(:name) { |n| "Test Model #{n}" }
    association :brand
    association :operating_system
  end
end
