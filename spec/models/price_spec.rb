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

  # context 'must not allow repetition' do
  #   subject(:v_range) { build :volume_range }

  #   before do
  #     create :volume_range, shipping_company: v_range.shipping_company, min_volume: 0, max_volume: 2
  #     v_range.shipping_company.reload
  #   end

  #   it 'of minimum volume' do
  #     expect(v_range).not_to allow_values(0, 1, 2)
  #       .for(:min_volume).with_message('não pode estar contido em intervalos já registrados')
  #   end

  #   it 'of maximum volume' do
  #     expect(v_range).not_to allow_values(1, 2)
  #       .for(:max_volume).with_message('não pode estar contido em intervalos já registrados')
  #   end

  #   it { is_expected.to allow_value(3).for(:min_volume) }
  #   it { is_expected.to allow_value(3).for(:max_volume) }
  # end
end
