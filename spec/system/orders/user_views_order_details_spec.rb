# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário visualiza detalhes de um pedido' do
  it 'com sucesso' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')
    order = Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                          delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                          recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 5, weight: 10,
                          distance: 30, estimated_delivery_time: 2, value: 2500, shipping_company: express)

    login_as user, scope: :user
    visit shipping_company_path 1
    click_on 'Pedidos'
    click_on order.code

    expect(current_path).to eq order_path 1
  end

  it 'sem estar autenticado' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                  delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                  recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 5, weight: 10,
                  distance: 30, estimated_delivery_time: 2, value: 2500, shipping_company: express)

    visit order_path 1

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
