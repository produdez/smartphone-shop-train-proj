# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "email#{n}@email.com" }
    password { 'passwordpassword' }
    role { 'user' }
  end
end
