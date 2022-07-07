# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    sequence(:email) { |number| "admin#{number}@sistemadefrete.com.br" }
    password { 'password' }
  end
end
