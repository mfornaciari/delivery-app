class PriceDistanceRange < ApplicationRecord
  validates :value, presence: true
  validates :min_distance, comparison: { greater_than_or_equal_to: 0 }
  validates :max_distance, comparison: { greater_than: 0 }
  validate :not_previously_registered
  validate :min_distance_less_than_max_distance

  belongs_to :shipping_company

  private

  def min_distance_less_than_max_distance
    return unless max_distance && min_distance

    errors.add(:min_distance, 'deve ser menor que distância máxima') if min_distance >= max_distance
  end

  def not_previously_registered
    return unless shipping_company

    shipping_company.price_distance_ranges.each do |drange|
      next if drange == self

      interval = (drange.min_distance..drange.max_distance)
      message = 'não pode estar contida em intervalos já registrados'
      errors.add(:min_distance, message) if interval.include? min_distance
      errors.add(:max_distance, message) if interval.include? max_distance
    end
  end
end
