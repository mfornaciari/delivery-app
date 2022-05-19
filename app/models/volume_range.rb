class VolumeRange < ApplicationRecord
  belongs_to :shipping_company
  has_many :weight_ranges
end
