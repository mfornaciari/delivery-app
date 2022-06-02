# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe '#valid?' do
    context 'Presença:' do
      it 'Falso quando modelo está em branco' do
        vehicle = described_class.new(model: '')

        vehicle.valid?

        expect(vehicle.errors[:model]).to include 'não pode ficar em branco'
      end

      it 'Falso quando marca está em branco' do
        vehicle = described_class.new(brand: '')

        vehicle.valid?

        expect(vehicle.errors[:brand]).to include 'não pode ficar em branco'
      end

      it 'Falso quando ano de produção está em branco' do
        vehicle = described_class.new(production_year: '')

        vehicle.valid?

        expect(vehicle.errors[:production_year]).to include 'não pode ficar em branco'
      end

      it 'Falso quando transportadora está em branco' do
        vehicle = described_class.new(shipping_company: nil)

        vehicle.valid?

        expect(vehicle.errors[:shipping_company]).to include 'é obrigatório(a)'
      end
    end

    context 'Formato:' do
      it 'Falso quando placa de identificação está vazia/em formato incorreto' do
        empty_vehicle = described_class.new(license_plate: '')
        first_invalid_vehicle = described_class.new(license_plate: 'ABCD123')
        second_invalid_vehicle = described_class.new(license_plate: 'ABC12345')
        third_invalid_vehicle = described_class.new(license_plate: 'ABCD1234')
        first_valid_vehicle = described_class.new(license_plate: 'ABC1D23')
        second_valid_vehicle = described_class.new(license_plate: 'ABC1234')

        [empty_vehicle, first_invalid_vehicle, second_invalid_vehicle, third_invalid_vehicle,
         first_valid_vehicle, second_valid_vehicle].each(&:valid?)

        expect(empty_vehicle.errors[:license_plate]).to include 'não é válido'
        expect(first_invalid_vehicle.errors[:license_plate]).to include 'não é válido'
        expect(second_invalid_vehicle.errors[:license_plate]).to include 'não é válido'
        expect(third_invalid_vehicle.errors[:license_plate]).to include 'não é válido'
        expect(first_valid_vehicle.errors.include?(:license_plate)).to be false
        expect(second_valid_vehicle.errors.include?(:license_plate)).to be false
      end
    end

    context 'Singularidade:' do
      it 'Falso quando placa de identificação é repetida' do
        express = create :express
        create :vehicle, shipping_company: express, license_plate: 'BRA3R52'
        vehicle = described_class.new(license_plate: 'BRA3R52')

        vehicle.valid?

        expect(vehicle.errors[:license_plate]).to include 'já está em uso'
      end
    end

    context 'Valor:' do
      it 'Falso quando ano de produção é < 1908 ou > ano atual' do
        first_invalid_vehicle = described_class.new(production_year: 1907)
        second_invalid_vehicle = described_class.new(production_year: 2023)
        valid_vehicle = described_class.new(production_year: 2022)

        [first_invalid_vehicle, second_invalid_vehicle, valid_vehicle].each(&:valid?)

        expect(first_invalid_vehicle.errors[:production_year]).to include('deve estar entre 1908 e o ano atual')
        expect(second_invalid_vehicle.errors[:production_year]).to include('deve estar entre 1908 e o ano atual')
        expect(valid_vehicle.errors.include?(:production_year)).to be false
      end

      it 'Falso quando carga máxima está vazia ou é <= 0' do
        empty_vehicle = described_class.new(maximum_load: '')
        first_invalid_vehicle = described_class.new(maximum_load: 0)
        second_invalid_vehicle = described_class.new(maximum_load: -1)
        valid_vehicle = described_class.new(maximum_load: 100_000)

        [empty_vehicle, first_invalid_vehicle, second_invalid_vehicle, valid_vehicle].each(&:valid?)

        expect(empty_vehicle.errors[:maximum_load]).to include('não pode ficar em branco')
        expect(first_invalid_vehicle.errors[:maximum_load]).to include('deve ser maior que 0')
        expect(second_invalid_vehicle.errors[:maximum_load]).to include('deve ser maior que 0')
        expect(valid_vehicle.errors.include?(:maximum_load)).to be false
      end
    end
  end
end
