# frozen_string_literal: true

FactoryBot.define do
  factory :route_update do
    date_and_time { 1.day.ago }
    latitude { 90 }
    longitude { 180 }
    order
  end
end
