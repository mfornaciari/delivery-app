class WeightRange < ApplicationRecord
  validates :value, presence: true
  validates :min_weight, comparison: { greater_than_or_equal_to: 0 }
  validates :max_weight, comparison: { greater_than: 0 }
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

    volume_range.weight_ranges.each do |wrange|
      next if wrange == self

      interval = (wrange.min_weight..wrange.max_weight)
      message = 'não pode estar contido em intervalos já registrados'
      errors.add(:min_weight, message) if interval.include? min_weight
      errors.add(:max_weight, message) if interval.include? max_weight
    end
  end
end
