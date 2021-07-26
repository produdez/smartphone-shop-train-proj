# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Internet.unique.username(specifier: 8) }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.unique.password(min_length: 6) }
    role { 'user' }
  end
end
