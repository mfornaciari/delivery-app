# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BudgetSearch, type: :model do
  describe '#valid?' do
    context 'Valor:' do
      it 'Falso quando altura está em branco ou é <= 0' do
        empty_search = described_class.new(height: '')
        invalid_search = described_class.new(height: 0)
        valid_search = described_class.new(height: 1)

        [empty_search, invalid_search, valid_search].each(&:valid?)

        expect(empty_search.errors[:height]).to include 'não pode ficar em branco'
        expect(invalid_search.errors[:height]).to include 'deve ser maior que 0'
        expect(valid_search.errors.include?(:height)).to be false
      end

      it 'Falso quando largura está em branco ou é <= 0' do
        empty_search = described_class.new(width: '')
        invalid_search = described_class.new(width: 0)
        valid_search = described_class.new(width: 1)

        [empty_search, invalid_search, valid_search].each(&:valid?)

        expect(empty_search.errors[:width]).to include 'não pode ficar em branco'
        expect(invalid_search.errors[:width]).to include 'deve ser maior que 0'
        expect(valid_search.errors.include?(:width)).to be false
      end

      it 'Falso quando profundidade está em branco ou é <= 0' do
        empty_search = described_class.new(depth: '')
        invalid_search = described_class.new(depth: 0)
        valid_search = described_class.new(depth: 1)

        [empty_search, invalid_search, valid_search].each(&:valid?)

        expect(empty_search.errors[:depth]).to include 'não pode ficar em branco'
        expect(invalid_search.errors[:depth]).to include 'deve ser maior que 0'
        expect(valid_search.errors.include?(:depth)).to be false
      end

      it 'Falso quando peso está em branco ou é <= 0' do
        empty_search = described_class.new(weight: '')
        invalid_search = described_class.new(weight: 0)
        valid_search = described_class.new(weight: 1)

        [empty_search, invalid_search, valid_search].each(&:valid?)

        expect(empty_search.errors[:weight]).to include 'não pode ficar em branco'
        expect(invalid_search.errors[:weight]).to include 'deve ser maior que 0'
        expect(valid_search.errors.include?(:weight)).to be false
      end

      it 'Falso quando distância está em branco ou é <= 0' do
        empty_search = described_class.new(distance: '')
        invalid_search = described_class.new(distance: 0)
        valid_search = described_class.new(distance: 1)

        [empty_search, invalid_search, valid_search].each(&:valid?)

        expect(empty_search.errors[:distance]).to include 'não pode ficar em branco'
        expect(invalid_search.errors[:distance]).to include 'deve ser maior que 0'
        expect(valid_search.errors.include?(:distance)).to be false
      end
    end
  end

  describe '#set_volume_in_cubic_meters' do
    it 'deve definir volume em m³ multiplicando altura, largura e profundidade em cm' do
      admin = create :admin
      search = create :budget_search, height: 100, width: 100, depth: 100, admin: admin

      expect(search.volume).to eq 1
    end
  end
end
