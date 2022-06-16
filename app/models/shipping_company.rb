# frozen_string_literal: true

class ShippingCompany < ApplicationRecord
  validates :brand_name, :corporate_name, :address, :city, :state, presence: true
  validates :email_domain, format: { with: /\A[a-z0-9]+\.[a-z]+(.[a-z]+)?\z/i }
  validates :registration_number, format: { with: /\A\d{14}\z/ }
  validates :registration_number, uniqueness: true

  has_many :vehicles, dependent: :destroy
  has_many :volume_ranges, dependent: :destroy
  has_many :weight_ranges, through: :volume_ranges
  has_many :price_distance_ranges, dependent: :destroy
  has_many :time_distance_ranges, dependent: :destroy
  has_many :users, dependent: :nullify
  has_many :orders, dependent: :nullify

  STATES = %w[AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO].freeze

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
