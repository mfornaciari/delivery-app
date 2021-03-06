# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeightRange, type: :model do
  describe '#valid?' do
    context 'Presença:' do
      it 'Falso quando intervalo de volume está em branco' do
        wrange = described_class.new(volume_range: nil)

        wrange.valid?

        expect(wrange.errors[:volume_range]).to include 'é obrigatório(a)'
      end

      it 'Falso quando valor está em branco' do
        wrange = described_class.new(value: '')

        wrange.valid?

        expect(wrange.errors[:value]).to include 'não pode ficar em branco'
      end
    end

    context 'Valor:' do
      it 'Falso quando peso mínimo está em branco ou é < 0' do
        empty_range = described_class.new(min_weight: '')
        invalid_range = described_class.new(min_weight: -1)
        valid_range = described_class.new(min_weight: 0)

        [empty_range, invalid_range, valid_range].each(&:valid?)

        expect(empty_range.errors[:min_weight]).to include 'não pode ficar em branco'
        expect(invalid_range.errors[:min_weight]).to include 'deve ser maior ou igual a 0'
        expect(valid_range.errors.include?(:min_weight)).to be false
      end

      it 'Falso quando peso máximo está em branco ou é < 1' do
        empty_range = described_class.new(max_weight: '')
        invalid_range = described_class.new(max_weight: 0)
        valid_range = described_class.new(max_weight: 1)

        [empty_range, invalid_range, valid_range].each(&:valid?)

        expect(empty_range.errors[:max_weight]).to include 'não pode ficar em branco'
        expect(invalid_range.errors[:max_weight]).to include 'deve ser maior que 0'
        expect(valid_range.errors.include?(:max_weight)).to be false
      end

      it 'Falso quando peso mínimo >= peso máximo' do
        first_invalid_range = described_class.new(min_weight: 5, max_weight: 5)
        second_invalid_range = described_class.new(min_weight: 6, max_weight: 5)

        [first_invalid_range, second_invalid_range].each(&:valid?)

        expect(first_invalid_range.errors[:min_weight]).to include 'deve ser menor que o peso máximo'
        expect(second_invalid_range.errors[:min_weight]).to include 'deve ser menor que o peso máximo'
      end
    end

    context 'Singularidade:' do
      it 'Falso quando peso mínimo está incluso em intervalos já cadastrados' do
        express = create :express
        vrange = create :volume_range, shipping_company: express
        create :weight_range, volume_range: vrange, min_weight: 0, max_weight: 10
        invalid_range = described_class.new(volume_range: vrange, min_weight: 0)
        valid_range = described_class.new(volume_range: vrange, min_weight: 11)

        vrange.reload
        [invalid_range, valid_range].each(&:valid?)

        expect(invalid_range.errors[:min_weight]).to include('não pode estar contido em intervalos já registrados')
        expect(valid_range.errors.include?(:min_weight)).to be false
      end

      it 'Falso quando peso máximo está incluso em intervalos já cadastrados' do
        express = create :express
        vrange = create :volume_range, shipping_company: express
        create :weight_range, volume_range: vrange, min_weight: 0, max_weight: 10
        invalid_range = described_class.new(volume_range: vrange, max_weight: 10)
        valid_range = described_class.new(volume_range: vrange, max_weight: 11)

        vrange.reload
        [invalid_range, valid_range].each(&:valid?)

        expect(invalid_range.errors[:max_weight]).to include('não pode estar contido em intervalos já registrados')
        expect(valid_range.errors.include?(:max_weight)).to be false
      end
    end
  end
end
