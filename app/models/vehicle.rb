class Vehicle < ApplicationRecord
  validates :model, :brand, presence: true
  validates :license_plate, format: { with: /\A[a-z]{3}\d[\d|[a-z]]\d{2}\z/i }
  validates :license_plate, uniqueness: true
  validates :production_year, inclusion: {
    in: 1908..Date.current.year,
    message: 'deve estar entre 1908 e o ano atual'
  }
  validates :maximum_load, comparison: { greater_than: 0 }

  belongs_to :shipping_company
end
