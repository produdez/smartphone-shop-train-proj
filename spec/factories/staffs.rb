# frozen_string_literal: true

FactoryBot.define do
  factory :staff do
    role { 'employee' }
    association :user
    association :store
  end
end
