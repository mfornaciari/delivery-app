# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShippingCompany, type: :model do
  it { is_expected.to have_one(:address) }
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:vehicles) }
  it { is_expected.to have_many(:volume_ranges) }
  it { is_expected.to have_many(:weight_ranges).through(:volume_ranges) }
  it { is_expected.to have_many(:price_distance_ranges) }
  it { is_expected.to have_many(:time_distance_ranges) }
  it { is_expected.to have_many(:orders) }

  it { is_expected.to validate_presence_of(:brand_name) }
  it { is_expected.to validate_presence_of(:corporate_name) }
  it { is_expected.to validate_presence_of(:email_domain) }
  it { is_expected.to validate_presence_of(:registration_number) }

  it { is_expected.not_to allow_values('express', '-express.com.br', 'express.com-').for(:email_domain) }
  it { is_expected.to allow_values('express.com.br', 'ajato.com').for(:email_domain) }
  it { is_expected.not_to allow_values(8_891_540_000_121, 128_891_540_000_121).for(:registration_number) }
  it { is_expected.to allow_value(28_891_540_000_121).for(:registration_number) }

  it { is_expected.to validate_uniqueness_of(:registration_number) }
end
