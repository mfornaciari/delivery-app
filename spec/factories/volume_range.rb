# frozen_string_literal: true

FactoryBot.define do
  factory :volume_range do
    min_volume { 0 }
    max_volume { 20 }
    association :shipping_company, factory: :express
  end
end
