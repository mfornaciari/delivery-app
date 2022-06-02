# frozen_string_literal: true

FactoryBot.define do
  factory :shipping_company do
    factory :express do
      brand_name { 'Express' }
      corporate_name { 'Express Transportes Ltda.' }
      email_domain { 'express.com.br' }
      registration_number { 28_891_540_000_121 }
      address { 'Avenida A, 10' }
      city { 'Rio de Janeiro' }
      state { 'RJ' }
    end

    factory :a_jato do
      brand_name { 'A Jato' }
      corporate_name { 'A Jato S.A.' }
      email_domain { 'ajato.com' }
      registration_number { 19_824_380_000_107 }
      address { 'Avenida B, 23' }
      city { 'Natal' }
      state { 'RN' }
    end
  end
end
