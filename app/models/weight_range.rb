# frozen_string_literal: true

class WeightRange < ApplicationRecord
  validates :min_weight, :max_weight, :value, presence: true
  validates :min_weight, numericality: { greater_than_or_equal_to: 0 }
  validates :max_weight, numericality: { greater_than: 0 }
  validate :not_previously_registered
  validate :min_weight_less_than_max_weight

  belongs_to :volume_range

  private

  def min_weight_less_than_max_weight
    return unless max_weight && min_weight

    errors.add(:min_weight, 'deve ser menor que o peso máximo') if min_weight >= max_weight
  end

  def not_previously_registered
    return unless volume_range

    previous_ranges.each do |wrange|
      interval = (wrange.min_weight..wrange.max_weight)
      errors.add(:min_weight, I18n.t('range_previously_registered')) if interval.include? min_weight
      errors.add(:max_weight, I18n.t('range_previously_registered')) if interval.include? max_weight
    end
  end

  def previous_ranges
    volume_range.weight_ranges - [self]
  end
end
