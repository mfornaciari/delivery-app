# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VolumeRange, type: :model do
  it { is_expected.to belong_to(:shipping_company) }

  it { is_expected.to validate_presence_of(:min_volume).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:max_volume).with_message('não pode ficar em branco') }

  it { is_expected.to validate_numericality_of(:min_volume).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:max_volume).is_greater_than(0) }

  it 'must not allow minimum volume to be >= maximum volume' do
    range = build :volume_range, max_volume: 5

    expect(range).not_to allow_values(5, 6).for(:min_volume).with_message('deve ser menor que o volume máximo')
    expect(range).to allow_value(4).for(:min_volume)
  end

  context 'must not allow repetition' do
    subject(:v_range) { build :volume_range }

    before do
      create :volume_range, shipping_company: v_range.shipping_company, min_volume: 0, max_volume: 2
      v_range.shipping_company.reload
    end

    it 'of minimum volume' do
      expect(v_range).not_to allow_values(0, 1, 2)
        .for(:min_volume).with_message('não pode estar contido em intervalos já registrados')
    end

    it 'of maximum volume' do
      expect(v_range).not_to allow_values(1, 2)
        .for(:max_volume).with_message('não pode estar contido em intervalos já registrados')
    end

    it { is_expected.to allow_value(3).for(:min_volume) }
    it { is_expected.to allow_value(3).for(:max_volume) }
  end
end
