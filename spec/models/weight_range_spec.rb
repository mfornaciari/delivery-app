# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeightRange, type: :model do
  it { is_expected.to belong_to(:volume_range) }

  it { is_expected.to validate_presence_of(:value).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:min_weight).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:max_weight).with_message('não pode ficar em branco') }

  it { is_expected.to validate_numericality_of(:min_weight).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:max_weight).is_greater_than(0) }

  it 'must not allow minimum weight to be >= maximum weight' do
    range = build :weight_range, max_weight: 5

    expect(range).not_to allow_values(5, 6).for(:min_weight).with_message('deve ser menor que o peso máximo')
    expect(range).to allow_value(4).for(:min_weight)
  end

  context 'must not allow repetition' do
    subject(:w_range) { build :weight_range }

    before do
      create :weight_range, volume_range: w_range.volume_range, min_weight: 0, max_weight: 2
      w_range.volume_range.reload
    end

    it 'of minimum weight' do
      expect(w_range).not_to allow_values(0, 1, 2)
        .for(:min_weight).with_message('não pode estar contido em intervalos já registrados')
    end

    it 'of maximum weight' do
      expect(w_range).not_to allow_values(1, 2)
        .for(:max_weight).with_message('não pode estar contido em intervalos já registrados')
    end

    it { is_expected.to allow_value(3).for(:min_weight) }
    it { is_expected.to allow_value(3).for(:max_weight) }
  end
end
