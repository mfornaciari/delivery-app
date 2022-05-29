require 'rails_helper'

describe 'Usuário atualiza rota do pedido' do
  it 'com sucesso' do
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
                          status: :accepted, vehicle:)
    current_time = Time.current

    login_as user, scope: :user
    visit shipping_company_path 1
    click_on 'Pedidos'
    click_on order.code
    within('#route_update') do
      fill_in 'Latitude', with: '-45.0'
      fill_in 'Longitude', with: '90.1'
      fill_in 'Data e hora', with: current_time
      click_on 'Atualizar rota de entrega'
    end

    expect(page).to have_content 'Rota de entrega do pedido atualizada.'
    expect(page).to have_content 'Rota de entrega:'
    within_table('route') do
      within('#table_header') do
        expect(page).to have_content 'Data e hora'
        expect(page).to have_content 'Latitude'
        expect(page).to have_content 'Longitude'
      end
      within('#update_1') do
        expect(page).to have_content I18n.l(current_time)
        expect(page).to have_content '-45.0'
        expect(page).to have_content '90.1'
      end
    end
  end

  it 'com dados incompletos' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')
    vehicle = Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                              maximum_load: 100_000, shipping_company: express)
    Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                  delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                  recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 5, weight: 10,
                  distance: 30, estimated_delivery_time: 2, value: 2500, shipping_company: express,
                  status: :accepted, vehicle:)

    login_as user, scope: :user
    visit order_path 1
    click_on 'Atualizar rota de entrega'

    expect(page).to have_content 'Rota de entrega não atualizada.'
    expect(page).to have_content 'Latitude não pode ficar em branco'
    expect(page).to have_content 'Longitude não pode ficar em branco'
    expect(page).to have_content 'Data e hora não pode ficar em branco'
  end

  it 'com dados inválidos' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')
    vehicle = Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                              maximum_load: 100_000, shipping_company: express)
    Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                  delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                  recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 5, weight: 10,
                  distance: 30, estimated_delivery_time: 2, value: 2500, shipping_company: express,
                  status: :accepted, vehicle:)

    login_as user, scope: :user
    visit order_path 1
    fill_in 'Latitude', with: '-90.1'
    fill_in 'Longitude', with: '180.1'
    fill_in 'Data e hora', with: 1.second.from_now
    click_on 'Atualizar rota de entrega'

    expect(page).to have_content 'Rota de entrega não atualizada.'
    expect(page).to have_content 'Latitude deve estar entre -90 e 90'
    expect(page).to have_content 'Longitude deve estar entre -180 e 180'
    expect(page).to have_content 'Data e hora não podem estar no futuro'
  end

  it 'com data e hora anteriores à última atualização' do
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
                          status: :accepted, vehicle:)
    RouteUpdate.create!(date_and_time: Time.current, latitude: 45.0, longitude: 45.0, order:)

    login_as user, scope: :user
    visit order_path 1
    fill_in 'Data e hora', with: 1.second.ago
    click_on 'Atualizar rota de entrega'

    expect(page).to have_content 'Rota de entrega não atualizada.'
    expect(page).to have_content 'Data e hora não podem ser anteriores à última atualização'
  end
end
