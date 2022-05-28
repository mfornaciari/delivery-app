class Order < ApplicationRecord
  belongs_to :shipping_company

  validates :pickup_address, :pickup_city, :pickup_state, :delivery_address, :delivery_city, :delivery_state,
            :recipient_name, :product_code, presence: true

  before_validation :generate_code

  enum status: { pending: 0, rejected: 5, accepted: 10, finished: 15 }

  STATES = %w[AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO].freeze

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(15).upcase
  end
end
