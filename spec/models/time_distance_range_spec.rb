require 'rails_helper'

RSpec.describe TimeDistanceRange, type: :model do
  describe '#valid?' do
    context 'Presença:' do
      it 'Falso quando transportadora está em branco' do
        trange = TimeDistanceRange.new(shipping_company: nil)

        trange.valid?

        expect(trange.errors[:shipping_company]).to include 'é obrigatório(a)'
      end

      it 'Falso quando prazo está em branco' do
        trange = TimeDistanceRange.new(delivery_time: '')

        trange.valid?

        expect(trange.errors[:delivery_time]).to include 'não pode ficar em branco'
      end
    end

    context 'Valor:' do
      it 'Falso quando distância mínima está em branco ou é < 0 ' do
        empty_range = TimeDistanceRange.new(min_distance: '')
        invalid_range = TimeDistanceRange.new(min_distance: -1)
        valid_range = TimeDistanceRange.new(min_distance: 0)

        [empty_range, invalid_range, valid_range].each(&:valid?)

        expect(empty_range.errors[:min_distance]).to include 'não pode ficar em branco'
        expect(invalid_range.errors[:min_distance]).to include 'deve ser maior ou igual a 0'
        expect(valid_range.errors.include?(:min_distance)).to be false
      end

      it 'Falso quando distância máxima está em branco ou é < 1' do
        empty_range = TimeDistanceRange.new(max_distance: '')
        invalid_range = TimeDistanceRange.new(max_distance: 0)
        valid_range = TimeDistanceRange.new(max_distance: 1)

        [empty_range, invalid_range, valid_range].each(&:valid?)

        expect(empty_range.errors[:max_distance]).to include 'não pode ficar em branco'
        expect(invalid_range.errors[:max_distance]).to include 'deve ser maior que 0'
        expect(valid_range.errors.include?(:max_distance)).to be false
      end

      it 'Falso quando distância mínima >= distância máxima' do
        first_invalid_range = TimeDistanceRange.new(min_distance: 5, max_distance: 5)
        second_invalid_range = TimeDistanceRange.new(min_distance: 6, max_distance: 5)

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
        TimeDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2)
        invalid_range = TimeDistanceRange.new(shipping_company: express, min_distance: 0)
        valid_range = TimeDistanceRange.new(shipping_company: express, min_distance: 101)

        express.reload
        [invalid_range, valid_range].each(&:valid?)

        expect(invalid_range.errors[:min_distance]).to include('não pode estar contida em intervalos já registrados')
        expect(valid_range.errors.include?(:min_distance)).to be false
      end

      it 'Falso quando distância máxima está inclusa em intervalos já cadastrados' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        TimeDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2)
        invalid_range = TimeDistanceRange.new(shipping_company: express, max_distance: 100)
        valid_range = TimeDistanceRange.new(shipping_company: express, max_distance: 101)

        express.reload
        [invalid_range, valid_range].each(&:valid?)

        expect(invalid_range.errors[:max_distance]).to include('não pode estar contida em intervalos já registrados')
        expect(valid_range.errors.include?(:max_distance)).to be false
      end

      it 'Falso quando prazo já está em uso' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        a_jato = ShippingCompany.create!(brand_name: 'A Jato', corporate_name: 'A Jato S.A.',
                                         email_domain: 'ajato.com', registration_number: 19_824_380_000_107,
                                         address: 'Avenida B, 23', city: 'Natal', state: 'RN')
        TimeDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2)
        TimeDistanceRange.create!(shipping_company: a_jato, min_distance: 0, max_distance: 100, delivery_time: 3)
        invalid_range = TimeDistanceRange.new(shipping_company: express, delivery_time: 2)
        valid_range = TimeDistanceRange.new(shipping_company: express, delivery_time: 3)

        express.reload
        [invalid_range, valid_range].each(&:valid?)

        expect(invalid_range.errors[:delivery_time]).to include('já está em uso')
        expect(valid_range.errors.include?(:delivery_time)).to be false
      end
    end
  end
end
