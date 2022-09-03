# frozen_string_literal: true

FactoryBot.define do
  factory :vehicle do
    license_plate { 'BRA3R52' }
    brand { 'Fiat ' }
    model { 'Uno' }
    production_year { 1992 }
    maximum_load { 100_000 }
    association :shipping_company, factory: :express
  end
end
