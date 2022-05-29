require 'rails_helper'

describe 'Visitante busca status de pedido' do
  it 'informando seu código' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    vehicle = Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                              maximum_load: 100_000, shipping_company: express)
    order = Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                          delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                          recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 5, weight: 10,
                          distance: 30, estimated_delivery_time: 2, value: 2500, shipping_company: express,
                          status: :accepted, vehicle:)
    RouteUpdate.create!(latitude: 45.0, longitude: 60.2, date_and_time: 2.days.ago, order:)
    RouteUpdate.create!(latitude: 62.0, longitude: 65.2, date_and_time: 1.days.ago, order:)

    visit root_path
    fill_in 'Código do pedido', with: order.code
    click_on 'Consultar'

    expect(page).to have_content "Pedido #{order.code}"
    expect(page).to have_content 'Transportadora: Express Transportes Ltda.'
    expect(page).to have_content 'Veículo responsável: BRA3R52 (Fiat Uno)'
    expect(page).to have_content 'Endereço de retirada: Rua Rio Vermelho, n. 10 - Natal/RN'
    expect(page).to have_content 'Endereço de entrega: Rua Rio Verde, n. 10 - Aracaju/SE'
    expect(page).to have_content 'Atualizações de trajeto:'
    expect(page).to have_content "#{I18n.l(2.days.ago)}: Latitude 45.0, Longitude 60.2"
    expect(page).to have_content "#{I18n.l(1.day.ago)}: Latitude 62.0, Longitude 65.2"
  end

  it 'informando um código incorreto' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    vehicle = Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                              maximum_load: 100_000, shipping_company: express)
    Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                  delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                  recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 5, weight: 10,
                  distance: 30, estimated_delivery_time: 2, value: 2500, shipping_company: express,
                  status: :accepted, vehicle:)

    visit root_path
    fill_in 'Código do pedido', with: 'ABCDE12345ABCDE'
    click_on 'Consultar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Não há pedidos aceitos com esse código.'
  end

  it 'que ainda não foi aceito' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    order = Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                          delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                          recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 5, weight: 10,
                          distance: 30, estimated_delivery_time: 2, value: 2500, shipping_company: express)

    visit root_path
    fill_in 'Código do pedido', with: order.code
    click_on 'Consultar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Não há pedidos aceitos com esse código.'
  end

  it 'que foi finalizado' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    vehicle = Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                              maximum_load: 100_000, shipping_company: express)
    order = Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                          delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                          recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 5, weight: 10,
                          distance: 30, estimated_delivery_time: 2, value: 2500, shipping_company: express,
                          status: :finished, vehicle:)
    RouteUpdate.create!(latitude: 45.0, longitude: 60.2, date_and_time: 2.days.ago, order:)

    visit root_path
    fill_in 'Código do pedido', with: order.code
    click_on 'Consultar'

    expect(page).to have_content 'Pedido entregue.'
  end
end
