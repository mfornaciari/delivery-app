# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    kind { :company }
    association :addressable, factory: :express
    sequence(:line1) { |n| "Rua Rio Verde, #{n}" }
    city { 'Rio de Janeiro' }
    state { :RJ }

    trait :for_a_jato do
      kind { :company }
      association :addressable, factory: :a_jato
    end

    trait :for_order_pickup do
      kind { :pickup }
      association :addressable, factory: :order
    end

    trait :for_order_delivery do
      kind { :delivery }
      association :addressable, factory: :order
    end
  end
end
