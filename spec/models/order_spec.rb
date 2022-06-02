# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    context 'Presença:' do
      it 'Falso quando endereço de retirada está em branco' do
        order = described_class.new(pickup_address: '')

        order.valid?

        expect(order.errors[:pickup_address]).to include 'não pode ficar em branco'
      end

      it 'Falso quando cidade de retirada está em branco' do
        order = described_class.new(pickup_city: '')

        order.valid?

        expect(order.errors[:pickup_city]).to include 'não pode ficar em branco'
      end

      it 'Falso quando estado de retirada está em branco' do
        order = described_class.new(pickup_state: '')

        order.valid?

        expect(order.errors[:pickup_state]).to include 'não pode ficar em branco'
      end

      it 'Falso quando endereço de entrega está em branco' do
        order = described_class.new(delivery_address: '')

        order.valid?

        expect(order.errors[:delivery_address]).to include 'não pode ficar em branco'
      end

      it 'Falso quando cidade de entrega está em branco' do
        order = described_class.new(delivery_city: '')

        order.valid?

        expect(order.errors[:delivery_city]).to include 'não pode ficar em branco'
      end

      it 'Falso quando estado de entrega está em branco' do
        order = described_class.new(delivery_state: '')

        order.valid?

        expect(order.errors[:delivery_state]).to include 'não pode ficar em branco'
      end

      it 'Falso quando destinatário(a) está em branco' do
        order = described_class.new(recipient_name: '')

        order.valid?

        expect(order.errors[:recipient_name]).to include 'não pode ficar em branco'
      end

      it 'Falso quando código do produto está em branco' do
        order = described_class.new(product_code: '')

        order.valid?

        expect(order.errors[:product_code]).to include 'não pode ficar em branco'
      end
    end
  end

  describe 'Gera um código aleatório' do
    it 'ao criar um novo pedido' do
      express = create :express
      order = create :order, shipping_company: express

      order.save!

      expect(order.code).not_to be_empty
      expect(order.code.length).to eq 15
    end

    it 'e ele é único' do
      express = create :express
      first_order = create :order, shipping_company: express
      second_order = create :order, shipping_company: express

      second_order.save!

      expect(second_order.code).not_to eq first_order.code
    end

    it 'e ele não muda após atualização' do
      express = create :express
      order = create :order, shipping_company: express

      original_code = order.code
      order.accepted!

      expect(order.code).to eq original_code
    end
  end
end
