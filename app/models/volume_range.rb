class VolumeRange < ApplicationRecord
  validates :min_volume, comparison: { greater_than_or_equal_to: 0 }
  validates :max_volume, comparison: { greater_than_or_equal_to: 1 }
  validate :not_previously_registered

  belongs_to :shipping_company
  has_many :weight_ranges

  private

  def not_previously_registered
    return unless shipping_company

    shipping_company.volume_ranges.each do |vrange|
      if (vrange.min_volume..vrange.max_volume).include? min_volume
        errors.add :min_volume, 'não pode estar contido em intervalos já registrados'
      end
      if (vrange.min_volume..vrange.max_volume).include? max_volume
        errors.add :max_volume, 'não pode estar contido em intervalos já registrados'
      end
    end
  end
end
