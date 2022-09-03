# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShippingCompany, type: :model do
  subject(:company) { build :shipping_company }

  it { is_expected.to have_one(:address) }
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:vehicles) }
  it { is_expected.to have_many(:volume_ranges) }
  it { is_expected.to have_many(:weight_ranges).through(:volume_ranges) }
  it { is_expected.to have_many(:price_distance_ranges) }
  it { is_expected.to have_many(:time_distance_ranges) }
  it { is_expected.to have_many(:orders) }

  it { is_expected.to validate_presence_of(:brand_name).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:corporate_name).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:email_domain).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:registration_number).with_message('não pode ficar em branco') }

  it { is_expected.to validate_uniqueness_of(:registration_number).with_message('já está em uso') }

  it 'must not allow incorrect format for e-mail domain' do
    expect(company).not_to allow_values('express', '-express.com.br', 'express.com-')
      .for(:email_domain).with_message('não é válido')
    expect(company).to allow_values('express.com.br', 'ajato.com')
      .for(:email_domain)
  end

  it 'must not allow incorrect format for registration number' do
    expect(company).not_to allow_values(8_891_540_000_121, 128_891_540_000_121)
      .for(:registration_number).with_message('não é válido')
    expect(company).to allow_value(28_891_540_000_121)
      .for(:registration_number)
  end

  describe '#delivery_time' do
    subject(:company) { create :express }

    it 'must return delivery time for provided distance / nil if no time registered' do
      create(:time_distance_range,
             shipping_company: company,
             min_distance: 0,
             max_distance: 20,
             delivery_time: 1)
      create(:time_distance_range,
             shipping_company: company,
             min_distance: 21,
             max_distance: 40,
             delivery_time: 2)

      expect(company.delivery_time(distance: 20)).to eq 1
      expect(company.delivery_time(distance: 21)).to eq 2
      expect(company.delivery_time(distance: 41)).to be_nil
    end
  end

  describe '#value' do
    subject(:company) { create :express }

    it 'must return value for provided volume, weight and distance / nil if no value registered' do
      v_range1 = create :volume_range, shipping_company: company, min_volume: 0, max_volume: 20
      create :weight_range, volume_range: v_range1, min_weight: 0, max_weight: 20, value: 5
      create :weight_range, volume_range: v_range1, min_weight: 21, max_weight: 40, value: 15
      v_range2 = create :volume_range, shipping_company: company, min_volume: 21, max_volume: 40
      create :weight_range, volume_range: v_range2, min_weight: 0, max_weight: 20, value: 10

      expect(company.value(volume: 20, weight: 20, distance: 10)).to eq 50
      expect(company.value(volume: 20, weight: 21, distance: 10)).to eq 150
      expect(company.value(volume: 21, weight: 20, distance: 10)).to eq 100
      expect(company.value(volume: 41, weight: 20, distance: 10)).to be_nil
      expect(company.value(volume: 20, weight: 41, distance: 10)).to be_nil
    end

    it 'must return minimum value for distance if it is higher than the calculated value' do
      v_range1 = create :volume_range, shipping_company: company, min_volume: 0, max_volume: 20
      create :weight_range, volume_range: v_range1, min_weight: 0, max_weight: 20, value: 5
      create :price_distance_range, shipping_company: company, min_distance: 0, max_distance: 20, value: 100

      expect(company.value(volume: 20, weight: 20, distance: 19)).to eq 100
      expect(company.value(volume: 20, weight: 20, distance: 21)).to eq 105
    end
  end
end
