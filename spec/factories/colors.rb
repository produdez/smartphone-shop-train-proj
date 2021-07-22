# frozen_string_literal: true

FactoryBot.define do
  factory :color do
    sequence(:name) { |n| "Color #{n}" }
  end
end
