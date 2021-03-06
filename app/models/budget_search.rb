# frozen_string_literal: true

class BudgetSearch < ApplicationRecord
  belongs_to :admin

  validates :height, :width, :depth, :weight, :distance, comparison: { greater_than: 0 }

  before_create :set_volume_in_cubic_meters

  private

  def set_volume_in_cubic_meters
    self.volume = (height * width * depth) / 1_000_000
  end
end
