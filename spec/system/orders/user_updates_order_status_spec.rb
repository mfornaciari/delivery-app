# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário atualiza o status de um pedido' do
  context 'e aceita-o' do
    it 'com sucesso' do
      express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                        email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                        address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
      user = User.create!(email: 'usuario@express.com.br', password: 'password')
      Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                      maximum_load: 100_000, shipping_company: express)
      Vehicle.create!(license_plate: 'ARG4523', brand: 'Volkswagen', model: 'Fusca', production_year: 1971,
                      maximum_load: 40_000, shipping_company: express)
      order = Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                            delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                            recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 5, weight: 10,
                            distance: 30, estimated_delivery_time: 2, value: 2500, shipping_company: express)

      login_as user, scope: :user
      visit shipping_company_path 1
      click_on 'Pedidos'
      click_on order.code
      select 'ARG4523', from: 'Veículo responsável'
      click_on 'Aceitar pedido'

      expect(page).to have_current_path order_path 1
      expect(page).to have_content 'Pedido aceito.'
      expect(page).to have_content 'Status: Aceito'
      expect(page).to have_content 'Veículo responsável: ARG4523'
    end

    it 'sem escolher veículo' do
      express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                        email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                        address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
      user = User.create!(email: 'usuario@express.com.br', password: 'password')
      Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                      maximum_load: 100_000, shipping_company: express)
      order = Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                            delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                            recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 5, weight: 10,
                            distance: 30, estimated_delivery_time: 2, value: 2500, shipping_company: express)

      login_as user, scope: :user
      visit shipping_company_path 1
      click_on 'Pedidos'
      click_on order.code
      click_on 'Aceitar pedido'

      expect(page).to have_current_path order_path 1
      expect(page).to have_content 'Status não atualizado: atribua o pedido a um veículo.'
      within('#order_details') do
        expect(page).not_to have_content 'Veículo responsável'
        expect(page).not_to have_content 'Status: Aceito'
      end
    end
  end

  it ' e rejeita-o' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')
    Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                    maximum_load: 100_000, shipping_company: express)
    order = Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                          delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                          recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 5, weight: 10,
                          distance: 30, estimated_delivery_time: 2, value: 2500, shipping_company: express)

    login_as user, scope: :user
    visit shipping_company_path 1
    click_on 'Pedidos'
    click_on order.code
    click_on 'Rejeitar pedido'

    expect(page).to have_content 'Pedido rejeitado.'
    expect(page).to have_content 'Status: Rejeitado'
    expect(page).not_to have_select 'Veículo responsável'
    expect(page).not_to have_button 'Aceitar pedido'
  end

  it 'e finaliza-o' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')
    vehicle = Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                              maximum_load: 100_000, shipping_company: express)
    order = Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                          delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                          recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 5, weight: 10,
                          distance: 30, estimated_delivery_time: 2, value: 2500, shipping_company: express,
                          vehicle:, status: :accepted)

    login_as user, scope: :user
    visit shipping_company_path 1
    click_on 'Pedidos'
    click_on order.code
    click_on 'Finalizar pedido'

    expect(page).to have_content 'Pedido finalizado.'
    expect(page).to have_content 'Status: Finalizado'
    expect(page).not_to have_button 'Finalizar pedido'
    expect(page).not_to have_button 'Atualizar rota de entrega'
  end
end
