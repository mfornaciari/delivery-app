# frozen_string_literal: true

FactoryBot.define do
  factory :budget_search do
    height { 100 }
    width { 100 }
    depth { 100 }
    weight { 5 }
    distance { 50 }
    admin
  end
end
