class Price < ApplicationRecord
  belongs_to :shipping_company

  validates :min_volume, :max_volume, :min_weight, :max_weight, :value, presence: true
  validates :min_volume, :min_weight, :value, numericality: { greater_than_or_equal_to: 0 }
  validates :max_volume, :max_weight, numericality: { greater_than: 0 }
  validates :max_volume, comparison: { greater_than: :min_volume, message: 'deve ser maior que o volume mínimo' }
  validates :max_weight, comparison: { greater_than: :min_weight, message: 'deve ser maior que o peso mínimo' }

  private

  def min_volume_less_than_max_volume
    return unless max_volume && min_volume

    errors.add(:min_volume, 'deve ser menor que o volume máximo') if min_volume >= max_volume
  end
end
