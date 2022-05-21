require 'rails_helper'

RSpec.describe DistanceRange, type: :model do
  describe '#valid?' do
    context 'Presença:' do
      it 'Falso quando transportadora está em branco' do
        drange = DistanceRange.new(shipping_company: nil)

        drange.valid?

        expect(drange.errors[:shipping_company]).to include 'é obrigatório(a)'
      end

      it 'Falso quando valor está em branco' do
        drange = DistanceRange.new(value: '')

        drange.valid?

        expect(drange.errors[:value]).to include 'não pode ficar em branco'
      end
    end

    context 'Valor:' do
      it 'Falso quando distância mínima está em branco ou é < 0 ' do
        empty_range = DistanceRange.new(min_distance: '')
        invalid_range = DistanceRange.new(min_distance: -1)
        valid_range = DistanceRange.new(min_distance: 0)

        [empty_range, invalid_range, valid_range].each(&:valid?)

        expect(empty_range.errors[:min_distance]).to include 'não pode ficar em branco'
        expect(invalid_range.errors[:min_distance]).to include 'deve ser maior ou igual a 0'
        expect(valid_range.errors.include?(:min_distance)).to be false
      end

      it 'Falso quando distância máxima está em branco ou é < 1' do
        empty_range = DistanceRange.new(max_distance: '')
        invalid_range = DistanceRange.new(max_distance: 0)
        valid_range = DistanceRange.new(max_distance: 1)

        [empty_range, invalid_range, valid_range].each(&:valid?)

        expect(empty_range.errors[:max_distance]).to include 'não pode ficar em branco'
        expect(invalid_range.errors[:max_distance]).to include 'deve ser maior que 0'
        expect(valid_range.errors.include?(:max_distance)).to be false
      end

      it 'Falso quando distância mínima >= distância máxima' do
        first_invalid_range = DistanceRange.new(min_distance: 5, max_distance: 5)
        second_invalid_range = DistanceRange.new(min_distance: 6, max_distance: 5)

        [first_invalid_range, second_invalid_range].each(&:valid?)

        expect(first_invalid_range.errors[:min_distance]).to include 'deve ser menor que distância máxima'
        expect(second_invalid_range.errors[:min_distance]).to include 'deve ser menor que distância máxima'
      end
    end

    context 'Singularidade:' do
      it 'Falso quando distância mínima está inclusa em intervalos já cadastrados' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        DistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, value: 5000)
        invalid_range = DistanceRange.new(shipping_company: express, min_distance: 0)
        valid_range = DistanceRange.new(shipping_company: express, min_distance: 101)

        express.reload
        [invalid_range, valid_range].each(&:valid?)

        expect(invalid_range.errors[:min_distance]).to include('não pode estar contida em intervalos já registrados')
        expect(valid_range.errors.include?(:min_distance)).to be false
      end

      it 'Falso quando distância máxima está inclusa em intervalos já cadastrados' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        DistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, value: 5000)
        invalid_range = DistanceRange.new(shipping_company: express, max_distance: 100)
        valid_range = DistanceRange.new(shipping_company: express, max_distance: 101)

        express.reload
        [invalid_range, valid_range].each(&:valid?)

        expect(invalid_range.errors[:max_distance]).to include('não pode estar contida em intervalos já registrados')
        expect(valid_range.errors.include?(:max_distance)).to be false
      end
    end
  end
end
