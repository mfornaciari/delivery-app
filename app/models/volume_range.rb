class VolumeRange < ApplicationRecord
  validates :min_volume, comparison: { greater_than_or_equal_to: 0 }
  validates :max_volume, comparison: { greater_than: 0 }
  validate :not_previously_registered
  validate :min_volume_less_than_max_volume

  belongs_to :shipping_company
  has_many :weight_ranges, dependent: :destroy
  accepts_nested_attributes_for :weight_ranges

  private

  def min_volume_less_than_max_volume
    return unless max_volume && min_volume

    errors.add(:min_volume, 'deve ser menor que o volume máximo') if min_volume >= max_volume
  end

  def not_previously_registered
    return unless shipping_company

    previous_ranges.each do |vrange|
      interval = (vrange.min_volume..vrange.max_volume)
      message = 'não pode estar contido em intervalos já registrados'
      errors.add(:min_volume, message) if interval.include? min_volume
      errors.add(:max_volume, message) if interval.include? max_volume
    end
  end

  def previous_ranges
    shipping_company.volume_ranges - [self]
  end
end
