require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe '#valid?' do
    context 'presença' do
      it 'falso quando modelo está em branco' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        vehicle = Vehicle.new(license_plate: 'BRA3R52', brand: 'Fiat', model: '', production_year: 1992,
                              maximum_load: 100_000, shipping_company: express)

        vehicle.valid?

        expect(vehicle.errors.full_messages.length).to eq 1
        expect(vehicle.errors.full_messages[0]).to eq 'Modelo não pode ficar em branco'
      end

      it 'falso quando marca está em branco' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        vehicle = Vehicle.new(license_plate: 'BRA3R52', brand: '', model: 'Uno', production_year: 1992,
                              maximum_load: 100_000, shipping_company: express)

        vehicle.valid?

        expect(vehicle.errors.full_messages.length).to eq 1
        expect(vehicle.errors.full_messages[0]).to eq 'Marca não pode ficar em branco'
      end

      it 'falso quando transportadora está em branco' do
        vehicle = Vehicle.new(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                              maximum_load: 100_000, shipping_company: nil)

        vehicle.valid?

        expect(vehicle.errors.full_messages.length).to eq 1
        expect(vehicle.errors.full_messages[0]).to eq 'Transportadora é obrigatório(a)'
      end
    end

    context 'formato' do
      it 'falso quando placa de identificação está vazia/em formato incorreto' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        first_invalid = Vehicle.new(license_plate: 'ABCD123', brand: 'Fiat', model: 'Uno',
                                    production_year: 1992, maximum_load: 100_000, shipping_company: express)
        second_invalid = Vehicle.new(license_plate: 'ABC12345', brand: 'Fiat', model: 'Uno',
                                     production_year: 1992, maximum_load: 100_000, shipping_company: express)
        third_invalid = Vehicle.new(license_plate: 'ABCD1234', brand: 'Fiat', model: 'Uno',
                                    production_year: 1992, maximum_load: 100_000, shipping_company: express)
        empty = Vehicle.new(license_plate: '', brand: 'Fiat', model: 'Uno', production_year: 1992,
                            maximum_load: 100_000, shipping_company: express)
        first_valid = Vehicle.new(license_plate: 'ABC1D23', brand: 'Fiat', model: 'Uno', production_year: 1992,
                                  maximum_load: 100_000, shipping_company: express)
        second_valid = Vehicle.new(license_plate: 'ABC1234', brand: 'Fiat', model: 'Uno', production_year: 1992,
                                   maximum_load: 100_000, shipping_company: express)

        [first_invalid, second_invalid, third_invalid, empty].each(&:valid?)

        expect(first_invalid.errors.full_messages.length).to eq 1
        expect(first_invalid.errors.full_messages[0]).to eq 'Placa de identificação não é válido'
        expect(second_invalid.errors.full_messages.length).to eq 1
        expect(second_invalid.errors.full_messages[0]).to eq 'Placa de identificação não é válido'
        expect(third_invalid.errors.full_messages.length).to eq 1
        expect(third_invalid.errors.full_messages[0]).to eq 'Placa de identificação não é válido'
        expect(empty.errors.full_messages.length).to eq 1
        expect(empty.errors.full_messages[0]).to eq 'Placa de identificação não é válido'
        expect(first_valid).to be_valid
        expect(second_valid).to be_valid
      end
    end

    context 'singularidade' do
      it 'falso quando placa de identificação é repetida' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                        maximum_load: 100_000, shipping_company: express)
        vehicle = Vehicle.new(license_plate: 'BRA3R52', brand: 'Volkswagen', model: 'Fusca', production_year: 1971,
                              maximum_load: 40_000, shipping_company: express)

        vehicle.valid?

        expect(vehicle.errors.full_messages.length).to eq 1
        expect(vehicle.errors.full_messages[0]).to eq 'Placa de identificação já está em uso'
      end
    end

    context 'valor' do
      it 'falso quando ano de produção está vazio, é < 1908 ou > ano atual' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        first_invalid = Vehicle.new(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno',
                                    production_year: 1907, maximum_load: 100_000, shipping_company: express)
        second_invalid = Vehicle.new(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno',
                                     production_year: 2023, maximum_load: 100_000, shipping_company: express)
        empty = Vehicle.new(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno',
                            production_year: '', maximum_load: 100_000, shipping_company: express)
        valid = Vehicle.new(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                            maximum_load: 100_000, shipping_company: express)

        [first_invalid, second_invalid, empty].each(&:valid?)

        expect(first_invalid.errors.full_messages.length).to eq 1
        expect(first_invalid.errors.full_messages[0]).to eq 'Ano de produção deve estar entre 1908 e o ano atual'
        expect(second_invalid.errors.full_messages.length).to eq 1
        expect(second_invalid.errors.full_messages[0]).to eq 'Ano de produção deve estar entre 1908 e o ano atual'
        expect(empty.errors.full_messages.length).to eq 1
        expect(empty.errors.full_messages[0]).to eq 'Ano de produção deve estar entre 1908 e o ano atual'
        expect(valid).to be_valid
      end

      it 'falso quando carga máxima está vazia ou é <= 0' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        first_invalid = Vehicle.new(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno',
                                    production_year: 1992, maximum_load: 0, shipping_company: express)
        second_invalid = Vehicle.new(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno',
                                     production_year: 1992, maximum_load: -1, shipping_company: express)
        empty = Vehicle.new(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno',
                            production_year: 1992, maximum_load: '', shipping_company: express)
        valid = Vehicle.new(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                            maximum_load: 100_000, shipping_company: express)

        [first_invalid, second_invalid, empty].each(&:valid?)

        expect(first_invalid.errors.full_messages.length).to eq 1
        expect(first_invalid.errors.full_messages[0]).to eq 'Carga máxima deve ser maior que 0'
        expect(second_invalid.errors.full_messages.length).to eq 1
        expect(second_invalid.errors.full_messages[0]).to eq 'Carga máxima deve ser maior que 0'
        expect(empty.errors.full_messages.length).to eq 1
        expect(empty.errors.full_messages[0]).to eq 'Carga máxima não pode ficar em branco'
        expect(valid).to be_valid
      end
    end
  end
end
