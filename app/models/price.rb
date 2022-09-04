class Price < ApplicationRecord
  belongs_to :shipping_company

  validates :min_volume, :max_volume, :min_weight, :max_weight, :value, presence: true
  validates :min_volume, :min_weight, :value, numericality: { greater_than_or_equal_to: 0 }
  validates :max_volume, :max_weight, numericality: { greater_than: 0 }
  validates :max_volume, comparison: { greater_than: :min_volume, message: I18n.t(:max_volume_lower_than_min) }
  validates :max_weight, comparison: { greater_than: :min_weight, message: I18n.t(:max_weight_lower_than_min) }

  private

  def min_volume_less_than_max_volume
    return unless max_volume && min_volume

    errors.add(:min_volume, 'deve ser menor que o volume máximo') if min_volume >= max_volume
  end
end
