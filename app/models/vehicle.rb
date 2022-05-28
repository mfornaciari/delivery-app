class Vehicle < ApplicationRecord
  validates :model, :brand, :production_year, presence: true
  validates :license_plate, format: { with: /\A[a-z]{3}\d[\d|[a-z]]\d{2}\z/i }
  validates :license_plate, uniqueness: true
  validates :maximum_load, comparison: { greater_than: 0 }

  validate :produced_in_valid_years

  belongs_to :shipping_company
  has_one :order

  private

  def produced_in_valid_years
    return unless production_year
    return if production_year.between?(1908, Date.current.year)

    errors.add(:production_year, 'deve estar entre 1908 e o ano atual')
  end
end
