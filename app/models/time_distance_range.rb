class TimeDistanceRange < ApplicationRecord
  validates :delivery_time, presence: true
  validates :delivery_time, uniqueness: { scope: :shipping_company_id }
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

    previous_ranges.each do |trange|
      interval = (trange.min_distance..trange.max_distance)
      message = 'não pode estar contida em intervalos já registrados'
      errors.add(:min_distance, message) if interval.include? min_distance
      errors.add(:max_distance, message) if interval.include? max_distance
    end
  end

  def previous_ranges
    shipping_company.time_distance_ranges - [self]
  end
end
