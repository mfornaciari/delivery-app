# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    for_express
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

    trait :for_express do
      association :shipping_company, factory: :express
    end

    trait :for_a_jato do
      association :shipping_company, factory: :a_jato
    end
  end
end
