class WeightRange < ApplicationRecord
  validates :min_weight, comparison: { greater_than_or_equal_to: 0 }
  validates :max_weight, comparison: { greater_than: 0 }
  validates :value, numericality: true
  validate :not_previously_registered

  belongs_to :volume_range

  private

  def not_previously_registered
    return unless volume_range

    volume_range.weight_ranges.each do |wrange|
      if (wrange.min_weight..wrange.max_weight).include? min_weight
        errors.add :min_weight, 'não pode estar contido em intervalos já registrados'
      end
      if (wrange.min_weight..wrange.max_weight).include? max_weight
        errors.add :max_weight, 'não pode estar contido em intervalos já registrados'
      end
    end
  end
end
