# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Price, type: :model do
  it { is_expected.to belong_to(:shipping_company) }

  it { is_expected.to validate_presence_of(:min_volume).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:max_volume).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:min_weight).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:max_weight).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:value).with_message('não pode ficar em branco') }

  it { is_expected.to validate_numericality_of(:min_volume).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:max_volume).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:min_weight).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:max_weight).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:value).is_greater_than_or_equal_to(0) }

  it 'does not allow maximum volume to be <= minimum volume' do
    price = build :price, min_volume: 2

    expect(price).not_to allow_values(1, 2).for(:max_volume).with_message('deve ser maior que o volume mínimo')
    expect(price).to allow_value(3).for(:max_volume)
  end

  it 'does not allow maximum weight to be <= minimum weight' do
    price = build :price, min_weight: 2

    expect(price).not_to allow_values(1, 2).for(:max_weight).with_message('deve ser maior que o peso mínimo')
    expect(price).to allow_value(3).for(:max_weight)
  end

  context 'when other prices exist for the same company' do
    let(:first_price) { create :price, min_volume: 0, max_volume: 2, min_weight: 0, max_weight: 2 }

    it 'does not allow repetition of weight when volume is repeated' do
      price = build :price, shipping_company: first_price.shipping_company, min_volume: 2, max_volume: 3
      first_price.shipping_company.reload

      expect(price).not_to allow_values(0, 1, 2)
        .for(:min_weight).with_message('não pode estar contido em intervalos já registrados')
      expect(price).not_to allow_values(0, 1, 2)
        .for(:max_weight).with_message('não pode estar contido em intervalos já registrados')
      expect(price).to allow_value(3).for(:min_weight)
      expect(price).to allow_value(4).for(:max_weight)
    end

    it 'does not allow repetition of volume when weight is repeated' do
      price = build :price, shipping_company: first_price.shipping_company, min_weight: 2, max_weight: 3
      first_price.shipping_company.reload

      expect(price).not_to allow_values(0, 1, 2)
        .for(:min_volume).with_message('não pode estar contido em intervalos já registrados')
      expect(price).not_to allow_values(0, 1, 2)
        .for(:max_volume).with_message('não pode estar contido em intervalos já registrados')
      expect(price).to allow_value(3).for(:min_volume)
      expect(price).to allow_value(4).for(:max_volume)
    end
  end
end
