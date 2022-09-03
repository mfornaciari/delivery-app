class Price < ApplicationRecord
  validates :min_volume, :max_volume, :min_weight, :max_weight, :value, presence: true
  validates :min_volume, :min_weight, :value, numericality: { greater_than_or_equal_to: 0 }
  validates :max_volume, :max_weight, numericality: { greater_than: 0 }
end
