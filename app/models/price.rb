class Price < ApplicationRecord
  validates :min_volume, :max_volume, :min_weight, :max_weight, :value, presence: true
end
