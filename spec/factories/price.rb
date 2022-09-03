# frozen_string_literal: true

FactoryBot.define do
  factory :price do
    min_volume { 0 }
    max_volume { 10 }
    min_weight { 0 }
    max_weight { 10 }
    value { 200 }
    association :shipping_company, factory: :express
  end
end
