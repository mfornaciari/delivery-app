require 'rails_helper'

RSpec.describe RouteUpdate, type: :model do
  describe '#valid?' do
    context 'Presença:' do
      it 'Falso quando data e hora estão em branco' do
        route_update = RouteUpdate.new(date_and_time: '')

        route_update.valid?

        expect(route_update.errors[:date_and_time]).to include 'não pode ficar em branco'
      end

      it 'Falso quando latitude está em branco' do
        route_update = RouteUpdate.new(latitude: '')

        route_update.valid?

        expect(route_update.errors[:latitude]).to include 'não pode ficar em branco'
      end

      it 'Falso quando longitude está em branco' do
        route_update = RouteUpdate.new(longitude: '')

        route_update.valid?

        expect(route_update.errors[:longitude]).to include 'não pode ficar em branco'
      end

      it 'Falso quando pedido está em branco' do
        route_update = RouteUpdate.new(order: nil)

        route_update.valid?

        expect(route_update.errors[:order]).to include 'é obrigatório(a)'
      end
    end

    context 'Valor:' do
      it 'Falso quando latitude < -90 ou > 90' do
        first_invalid_update = RouteUpdate.new(latitude: -90.1)
        second_invalid_update = RouteUpdate.new(latitude: 90.1)
        valid_update = RouteUpdate.new(latitude: 90.0)

        [first_invalid_update, second_invalid_update, valid_update].each(&:valid?)

        expect(first_invalid_update.errors[:latitude]).to include 'deve estar entre -90 e 90'
        expect(second_invalid_update.errors[:latitude]).to include 'deve estar entre -90 e 90'
        expect(valid_update.errors.include?(:latitude)).to be false
      end

      it 'Falso quando longitude < -180 ou > 180' do
        first_invalid_update = RouteUpdate.new(longitude: -180.1)
        second_invalid_update = RouteUpdate.new(longitude: 180.1)
        valid_update = RouteUpdate.new(longitude: 90.0)

        [first_invalid_update, second_invalid_update, valid_update].each(&:valid?)

        expect(first_invalid_update.errors[:longitude]).to include 'deve estar entre -180 e 180'
        expect(second_invalid_update.errors[:longitude]).to include 'deve estar entre -180 e 180'
        expect(valid_update.errors.include?(:longitude)).to be false
      end

      it 'Falso quando data e hora > data e hora atuais' do
        invalid_update = RouteUpdate.new(date_and_time: 1.second.from_now)
        valid_update = RouteUpdate.new(date_and_time: 1.second.ago)

        [invalid_update, valid_update].each(&:valid?)

        expect(invalid_update.errors[:date_and_time]).to include 'não podem estar no futuro'
        expect(valid_update.errors.include?(:date_and_time)).to be false
      end

      it 'Falso quando data e hora <= última data e hora cadastrada' do
        express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        vehicle = Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                                  maximum_load: 100_000, shipping_company: express)
        order = Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                              delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju',
                              delivery_state: 'SE', recipient_name: 'João da Silva', product_code: 'ABCD1234',
                              volume: 5, weight: 10, distance: 30, estimated_delivery_time: 2, value: 2500,
                              shipping_company: express, status: :accepted, vehicle:)
        RouteUpdate.create!(date_and_time: 1.second.ago, latitude: 90, longitude: 180, order:)
        second_update = RouteUpdate.new(date_and_time: 2.seconds.ago, order:)

        order.reload
        second_update.valid?

        expect(second_update.errors[:date_and_time]).to include 'não podem ser anteriores à última atualização'
      end
    end
  end
end
