# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    association :shipping_company, factory: :express
    pickup_address { association :address, addressable: instance, kind: :pickup }
    delivery_address { association :address, addressable: instance, kind: :delivery }
    recipient_name { 'João da Silva' }
    product_code { 'ABCD1234' }
    volume { 5 }
    weight { 10 }
    distance { 30 }
    estimated_delivery_time { 2 }
    value { 2500 }

    trait :without_addresses do
      pickup_address { nil }
      delivery_address { nil }
    end
  end
end
