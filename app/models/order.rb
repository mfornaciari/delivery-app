# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :shipping_company
  belongs_to :vehicle, optional: true
  has_one :pickup_address,
          -> { where(kind: :pickup) },
          class_name: 'Address',
          as: :addressable,
          dependent: :destroy
  has_one :delivery_address,
          -> { where(kind: :delivery) },
          class_name: 'Address',
          as: :addressable,
          dependent: :destroy
  has_many :route_updates, dependent: :destroy

  validates :recipient_name, :product_code, presence: true

  enum status: { pending: 0, rejected: 5, accepted: 10, finished: 15 }

  accepts_nested_attributes_for :pickup_address, :delivery_address

  before_create :generate_code

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(15).upcase
  end
end
