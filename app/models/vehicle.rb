# frozen_string_literal: true

class Vehicle < ApplicationRecord
  validates :model, :brand, :production_year, :license_plate, :maximum_load, presence: true
  validates :license_plate, uniqueness: true
  validates :license_plate, format: { with: /\A[a-z]{3}\d[\d|[a-z]]\d{2}\z/i }
  validates :maximum_load, numericality: { greater_than: 0 }

  validate :produced_in_valid_years

  belongs_to :shipping_company
  has_one :order, dependent: :nullify

  private

  def produced_in_valid_years
    return unless production_year
    return if production_year.between?(1908, Date.current.year)

    errors.add(:production_year, 'deve estar entre 1908 e o ano atual')
  end
end
