# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    pickup_address { 'Rua Rio Vermelho, n. 10' }
    pickup_city { 'Natal' }
    pickup_state { 'RN' }
    delivery_address { 'Rua Rio Verde, n. 10' }
    delivery_city { 'Aracaju' }
    delivery_state { 'SE' }
    recipient_name { 'João da Silva' }
    product_code { 'ABCD1234' }
    volume { 5 }
    weight { 10 }
    distance { 30 }
    estimated_delivery_time { 2 }
    value { 2500 }
    association :shipping_company
  end
end
