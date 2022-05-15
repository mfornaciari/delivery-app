class ShippingCompany < ApplicationRecord
  validates :brand_name, :corporate_name, :address, :city, :state, presence: true
  validates :email_domain, format: { with: /\A[a-z0-9]+\.[a-z]+(.[a-z]+)?\z/i }
  validates :registration_number, format: { with: /\A\d{14}\z/ }
  validates :registration_number, uniqueness: true
end
