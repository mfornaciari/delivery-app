# frozen_string_literal: true

class Price < ApplicationRecord
  belongs_to :shipping_company

  validates :min_volume, :max_volume, :min_weight, :max_weight, :value, presence: true
  validates :min_volume, :min_weight, :value, numericality: { greater_than_or_equal_to: 0 }
  validates :max_volume, :max_weight, numericality: { greater_than: 0 }
  validates :max_volume, comparison: { greater_than: :min_volume, message: I18n.t(:max_volume_lower_than_min) }
  validates :max_weight, comparison: { greater_than: :min_weight, message: I18n.t(:max_weight_lower_than_min) }

  validate :min_volume_not_repeated
  validate :max_volume_not_repeated
  validate :min_weight_not_repeated
  validate :max_weight_not_repeated

  private

  def min_volume_not_repeated
    return unless shipping_company && repeated_in_weights?(min_volume)

    errors.add(:min_volume, I18n.t('range_previously_registered'))
  end

  def max_volume_not_repeated
    return unless shipping_company && repeated_in_weights?(max_volume)

    errors.add(:max_volume, I18n.t('range_previously_registered'))
  end

  def min_weight_not_repeated
    return unless shipping_company && repeated_in_volumes?(min_weight)

    errors.add(:min_weight, I18n.t('range_previously_registered'))
  end

  def max_weight_not_repeated
    return unless shipping_company && repeated_in_volumes?(max_weight)

    errors.add(:max_weight, I18n.t('range_previously_registered'))
  end

  def repeated_in_weights?(volume)
    repeated_weights.any? { |price| (price.min_volume..price.max_volume).cover? volume }
  end

  def repeated_in_volumes?(weight)
    repeated_volumes.any? { |price| (price.min_weight..price.max_weight).cover? weight }
  end

  def repeated_weights
    shipping_company.prices.select do |price|
      range = (price.min_weight..price.max_weight)
      (range.cover? min_weight) || (range.cover? max_weight)
    end
  end

  def repeated_volumes
    shipping_company.prices.select do |price|
      range = (price.min_volume..price.max_volume)
      (range.cover? min_volume) || (range.cover? max_volume)
    end
  end
end
