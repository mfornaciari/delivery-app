# frozen_string_literal: true

FactoryBot.define do
  factory :price_distance_range do
    min_distance { 0 }
    max_distance { 1_000 }
    value { 5_000 }
    association :shipping_company, factory: :express
  end
end
