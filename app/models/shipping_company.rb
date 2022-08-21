# frozen_string_literal: true

class ShippingCompany < ApplicationRecord
  has_one :address,
          -> { where(kind: :company) },
          as: :addressable,
          dependent: :destroy
  has_many :users, dependent: :nullify
  has_many :vehicles, dependent: :destroy
  has_many :volume_ranges, dependent: :destroy
  has_many :weight_ranges, through: :volume_ranges
  has_many :price_distance_ranges, dependent: :destroy
  has_many :time_distance_ranges, dependent: :destroy
  has_many :orders, dependent: :nullify

  validates :brand_name, :corporate_name, :email_domain, :registration_number, presence: true
  validates :email_domain, format: { with: /\A[a-z0-9]+\.[a-z]+(.[a-z]+)?\z/i }
  validates :registration_number, format: { with: /\A\d{14}\z/ }
  validates :registration_number, uniqueness: true

  accepts_nested_attributes_for :address

  def delivery_time(distance:)
    time_distance_ranges.find_by('min_distance <= :distance AND max_distance >= :distance',
                                 distance:)&.delivery_time
  end

  def value(volume:, weight:, distance:)
    standard_value = weight_ranges.joins(:volume_range).find_by('min_weight <= :weight AND
                                                                max_weight >= :weight AND
                                                                volume_ranges.min_volume <= :volume AND
                                                                volume_ranges.max_volume >= :volume',
                                                                volume:, weight:)&.value
    return if standard_value.nil?

    standard_value *= distance
    min_value = min_value(distance:)
    min_value > standard_value ? min_value : standard_value
  end

  private

  def min_value(distance:)
    price_distance_ranges.find_by('min_distance <= :distance AND max_distance >= :distance',
                                  distance:)&.value
  end
end
