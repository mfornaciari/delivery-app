# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    for_express
    sequence(:line1) { |n| "Rua Rio Verde, #{n}" }
    city { 'Rio de Janeiro' }
    state { :RJ }

    trait :for_express do
      association :addressable, factory: :express
    end

    trait :for_a_jato do
      association :addressable, factory: :a_jato
    end

    trait :for_order do
      association :addressable, factory: :order
    end
  end
end
