# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'usuario@express.com.br' }
    password { 'password' }
  end
end
