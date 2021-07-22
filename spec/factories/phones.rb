# frozen_string_literal: true

FactoryBot.define do
  factory :phone do
    manufacture_year { 2016 }
    condition { 'old' }
    memory { 1500 }
    price { BigDecimal('654.89') }
    status { 'in_stock' }

    association :model
    association :color
    association :store
  end
end
