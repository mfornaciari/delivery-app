# frozen_string_literal: true

FactoryBot.define do
  factory :shipping_company do
    address { association :address, addressable: instance, kind: :company }

    trait :without_address do
      address { nil }
    end

    factory :express do
      brand_name { 'Express' }
      corporate_name { 'Express Transportes Ltda.' }
      email_domain { 'express.com.br' }
      registration_number { 28_891_540_000_121 }
    end

    factory :a_jato do
      brand_name { 'A Jato' }
      corporate_name { 'A Jato S.A.' }
      email_domain { 'ajato.com' }
      registration_number { 19_824_380_000_107 }
    end
  end
end
