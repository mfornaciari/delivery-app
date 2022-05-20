class VolumeRange < ApplicationRecord
  validates :min_volume, comparison: { greater_than_or_equal_to: 0 }
  validates :max_volume, comparison: { greater_than: 0 }
  validate :not_previously_registered

  belongs_to :shipping_company
  has_many :weight_ranges
  accepts_nested_attributes_for :weight_ranges

  private

  def not_previously_registered
    return unless shipping_company

    shipping_company.volume_ranges.each do |vrange|
      next if vrange == self

      interval = (vrange.min_volume..vrange.max_volume)
      message = 'não pode estar contido em intervalos já registrados'
      errors.add(:min_volume, message) if interval.include? min_volume
      errors.add(:max_volume, message) if interval.include? max_volume
    end
  end
end
