# frozen_string_literal: true

FactoryBot.define do
  factory :weight_range do
    min_weight { 0 }
    max_weight { 20 }
    value { 50 }
    association :volume_range
  end
end
