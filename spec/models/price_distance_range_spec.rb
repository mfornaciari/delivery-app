# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PriceDistanceRange, type: :model do
  subject(:pd_range) { build :price_distance_range }

  it { is_expected.to belong_to(:shipping_company) }

  it { is_expected.to validate_presence_of(:value).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:min_distance).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:max_distance).with_message('não pode ficar em branco') }

  it { is_expected.to validate_numericality_of(:min_distance).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:max_distance).is_greater_than(0) }

  it 'must not allow minimum distance to be >= maximum distance' do
    range = build :price_distance_range, max_distance: 5

    expect(range).not_to allow_values(5, 6).for(:min_distance).with_message('deve ser menor que distância máxima')
    expect(range).to allow_value(4).for(:min_distance)
  end

  context 'must not allow repetition' do
    subject(:pd_range) { build :price_distance_range }

    before do
      create :price_distance_range, shipping_company: pd_range.shipping_company, min_distance: 0, max_distance: 2
      pd_range.shipping_company.reload
    end

    it 'of minimum distance' do
      expect(pd_range).not_to allow_values(0, 1, 2)
        .for(:min_distance).with_message('não pode estar contida em intervalos já registrados')
    end

    it 'of maximum distance' do
      expect(pd_range).not_to allow_values(1, 2)
        .for(:max_distance).with_message('não pode estar contida em intervalos já registrados')
    end

    it { is_expected.to allow_value(3).for(:min_distance) }
    it { is_expected.to allow_value(3).for(:max_distance) }
  end
end
