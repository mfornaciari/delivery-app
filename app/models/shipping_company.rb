class ShippingCompany < ApplicationRecord
  validates :brand_name, :corporate_name, :address, :city, :state, presence: true
  validates :email_domain, format: { with: /\A[a-z0-9]+\.[a-z]+(.[a-z]+)?\z/i }
  validates :registration_number, format: { with: /\A\d{14}\z/ }
  validates :registration_number, uniqueness: true

  has_many :vehicles
  has_many :volume_ranges

  STATES = %w[AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO].freeze
end
