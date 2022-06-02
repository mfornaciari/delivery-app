# frozen_string_literal: true

FactoryBot.define do
  factory :price_distance_range do
    min_distance { 0 }
    max_distance { 1000 }
    value { 5_000 }
    association :shipping_company
  end
end
