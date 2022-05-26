class BudgetSearch < ApplicationRecord
  belongs_to :admin

  before_validation :set_volume_in_cubic_meters

  private

  def set_volume_in_cubic_meters
    self.volume = (height * width * depth) / 1_000_000
  end
end
