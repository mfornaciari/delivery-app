# frozen_string_literal: true

require 'rails_helper'

describe 'Visitante busca status de pedido' do
  it 'informando seu código' do
    express = create :express, corporate_name: 'Express Transportes Ltda.'
    vehicle = create :vehicle, shipping_company: express, license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno'
    order = create :order, shipping_company: express, vehicle: vehicle, status: :accepted,
                           pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                           delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE'
    create :route_update, latitude: 45.0, longitude: 60.2, date_and_time: 2.days.ago, order: order
    create :route_update, latitude: 62.0, longitude: 65.2, date_and_time: 1.day.ago, order: order

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
    express = create :express
    vehicle = create :vehicle, shipping_company: express
    allow(SecureRandom).to receive(:alphanumeric).and_return('12345EDCBAABCDE')
    create :order, shipping_company: express, vehicle: vehicle, status: :accepted

    visit root_path
    fill_in 'Código do pedido', with: 'ABCDE12345ABCDE'
    click_on 'Consultar'

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Não há pedidos aceitos com esse código.'
  end

  it 'que ainda não foi aceito' do
    express = create :express
    order = create :order, shipping_company: express, status: :pending

    visit root_path
    fill_in 'Código do pedido', with: order.code
    click_on 'Consultar'

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Não há pedidos aceitos com esse código.'
  end

  it 'que foi finalizado' do
    express = create :express
    vehicle = create :vehicle, shipping_company: express
    order = create :order, shipping_company: express, vehicle: vehicle, status: :finished

    visit root_path
    fill_in 'Código do pedido', with: order.code
    click_on 'Consultar'

    expect(page).to have_content 'Pedido entregue.'
  end
end
