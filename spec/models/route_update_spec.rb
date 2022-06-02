# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RouteUpdate, type: :model do
  describe '#valid?' do
    context 'Presença:' do
      it 'Falso quando data e hora estão em branco' do
        route_update = described_class.new(date_and_time: '')

        route_update.valid?

        expect(route_update.errors[:date_and_time]).to include 'não pode ficar em branco'
      end

      it 'Falso quando latitude está em branco' do
        route_update = described_class.new(latitude: '')

        route_update.valid?

        expect(route_update.errors[:latitude]).to include 'não pode ficar em branco'
      end

      it 'Falso quando longitude está em branco' do
        route_update = described_class.new(longitude: '')

        route_update.valid?

        expect(route_update.errors[:longitude]).to include 'não pode ficar em branco'
      end

      it 'Falso quando pedido está em branco' do
        route_update = described_class.new(order: nil)

        route_update.valid?

        expect(route_update.errors[:order]).to include 'é obrigatório(a)'
      end
    end

    context 'Valor:' do
      it 'Falso quando latitude < -90 ou > 90' do
        first_invalid_update = described_class.new(latitude: -90.1)
        second_invalid_update = described_class.new(latitude: 90.1)
        valid_update = described_class.new(latitude: 90.0)

        [first_invalid_update, second_invalid_update, valid_update].each(&:valid?)

        expect(first_invalid_update.errors[:latitude]).to include 'deve estar entre -90 e 90'
        expect(second_invalid_update.errors[:latitude]).to include 'deve estar entre -90 e 90'
        expect(valid_update.errors.include?(:latitude)).to be false
      end

      it 'Falso quando longitude < -180 ou > 180' do
        first_invalid_update = described_class.new(longitude: -180.1)
        second_invalid_update = described_class.new(longitude: 180.1)
        valid_update = described_class.new(longitude: 90.0)

        [first_invalid_update, second_invalid_update, valid_update].each(&:valid?)

        expect(first_invalid_update.errors[:longitude]).to include 'deve estar entre -180 e 180'
        expect(second_invalid_update.errors[:longitude]).to include 'deve estar entre -180 e 180'
        expect(valid_update.errors.include?(:longitude)).to be false
      end

      it 'Falso quando data e hora > data e hora atuais' do
        invalid_update = described_class.new(date_and_time: 1.second.from_now)
        valid_update = described_class.new(date_and_time: 1.second.ago)

        [invalid_update, valid_update].each(&:valid?)

        expect(invalid_update.errors[:date_and_time]).to include 'não podem estar no futuro'
        expect(valid_update.errors.include?(:date_and_time)).to be false
      end

      it 'Falso quando data e hora <= última data e hora cadastrada' do
        express = create :express
        vehicle = create :vehicle, shipping_company: express
        order = create :order, shipping_company: express, status: :accepted, vehicle: vehicle
        create :route_update, order: order, date_and_time: 1.second.ago
        second_update = described_class.new(order:, date_and_time: 2.seconds.ago)

        order.reload
        second_update.valid?

        expect(second_update.errors[:date_and_time]).to include 'não podem ser anteriores à última atualização'
      end
    end
  end
end
