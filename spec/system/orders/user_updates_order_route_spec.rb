# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário atualiza rota do pedido' do
  it 'com sucesso' do
    express = create :express, email_domain: 'express.com.br'
    user = create :user, email: 'usuario@express.com.br'
    vehicle = create :vehicle, shipping_company: express
    order = create :order, shipping_company: express, status: :accepted, vehicle: vehicle
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
    express = create :express, email_domain: 'express.com.br'
    user = create :user, email: 'usuario@express.com.br'
    vehicle = create :vehicle, shipping_company: express
    create :order, shipping_company: express, status: :accepted, vehicle: vehicle

    login_as user, scope: :user
    visit order_path 1
    click_on 'Atualizar rota de entrega'

    expect(page).to have_content 'Rota de entrega não atualizada.'
    expect(page).to have_content 'Latitude não pode ficar em branco'
    expect(page).to have_content 'Longitude não pode ficar em branco'
    expect(page).to have_content 'Data e hora não pode ficar em branco'
  end

  it 'com dados inválidos' do
    express = create :express
    user = create :user
    vehicle = create :vehicle, shipping_company: express
    create :order, shipping_company: express, status: :accepted, vehicle: vehicle

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
    express = create :express, email_domain: 'express.com.br'
    user = create :user, email: 'usuario@express.com.br'
    vehicle = create :vehicle, shipping_company: express
    order = create :order, shipping_company: express, status: :accepted, vehicle: vehicle
    current_time = Time.current
    create :route_update, order: order, date_and_time: current_time

    login_as user, scope: :user
    visit order_path 1
    fill_in 'Data e hora', with: 1.second.before(current_time)
    click_on 'Atualizar rota de entrega'

    expect(page).to have_content 'Rota de entrega não atualizada.'
    expect(page).to have_content 'Data e hora não podem ser anteriores à última atualização'
  end
end
