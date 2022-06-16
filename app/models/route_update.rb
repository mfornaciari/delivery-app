# frozen_string_literal: true

class RouteUpdate < ApplicationRecord
  validates :date_and_time, :latitude, :longitude, presence: true
  validates :latitude, inclusion: { in: -90..90, message: I18n.t('latitude_validation_error') }
  validates :longitude, inclusion: { in: -180..180, message: I18n.t('longitude_validation_error') }
  validate :not_future
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

  def not_future
    return unless date_and_time

    errors.add :date_and_time, message: 'não podem estar no futuro' if date_and_time > Time.current
  end
end
