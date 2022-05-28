require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'Gera um código aleatório' do
    it 'ao criar um novo pedido' do
      express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                        email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                        address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
      order = Order.new(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                        delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                        recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 5, weight: 10,
                        distance: 30, estimated_delivery_time: 2, value: 2500, shipping_company: express)

      order.save!

      expect(order.code).not_to be_empty
      expect(order.code.length).to eq 15
    end

    it 'e ele é único' do
      express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                        email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                        address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
      first_order = Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal',
                                  pickup_state: 'RN', delivery_address: 'Rua Rio Verde, n. 10',
                                  delivery_city: 'Aracaju', delivery_state: 'SE', recipient_name: 'João da Silva',
                                  product_code: 'ABCD1234', volume: 5, weight: 10, distance: 30,
                                  estimated_delivery_time: 2, value: 2500, shipping_company: express)
      second_order = Order.new(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal',
                               pickup_state: 'RN', delivery_address: 'Rua Rio Verde, n. 10',
                               delivery_city: 'Aracaju', delivery_state: 'SE', recipient_name: 'João da Silva',
                               product_code: 'ABCD1234', volume: 5, weight: 10, distance: 30,
                               estimated_delivery_time: 2, value: 2500, shipping_company: express)

      second_order.save!

      expect(second_order.code).not_to eq first_order.code
    end
  end
end
