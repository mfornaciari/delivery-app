# frozen_string_literal: true

class RouteUpdate < ApplicationRecord
  validates :date_and_time, :latitude, :longitude, presence: true
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :date_and_time, comparison: { less_than_or_equal_to: proc { Time.zone.now } }
  validate :after_last_update

  belongs_to :order

  private

  def after_last_update
    return unless order

    order.route_updates.each do |update|
      next if update == self

      message = 'não podem ser anteriores à última atualização'
      errors.add(:date_and_time, message) if date_and_time < update.date_and_time
    end
  end
end
