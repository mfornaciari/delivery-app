# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email { 'admin@sistemadefrete.com.br' }
    password { 'password' }
  end
end
