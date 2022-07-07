# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |number| "usuario#{number}@express.com.br" }
    password { 'password' }
  end
end
