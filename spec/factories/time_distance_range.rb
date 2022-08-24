# frozen_string_literal: true

FactoryBot.define do
  factory :time_distance_range do
    min_distance { 0 }
    max_distance { 100 }
    delivery_time { 2 }
    association :shipping_company, factory: :express
  end
end
