# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário atualiza rota do pedido' do
  let!(:express) { create :express }
  let(:user) { create :user }
  let(:vehicle) { create :vehicle, shipping_company: express }

  before { login_as user, scope: :user }

  it 'com sucesso' do
    order = create :order, shipping_company: express, status: :accepted, vehicle: vehicle
    current_time = Time.current

    visit shipping_company_path(express)
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
    order = create :order, shipping_company: express, status: :accepted, vehicle: vehicle

    visit order_path(order)
    click_on 'Atualizar rota de entrega'

    expect(page).to have_content 'Rota de entrega não atualizada.'
    expect(page).to have_content 'Latitude não pode ficar em branco'
    expect(page).to have_content 'Longitude não pode ficar em branco'
    expect(page).to have_content 'Data e hora não pode ficar em branco'
  end

  it 'com dados inválidos' do
    order = create :order, shipping_company: express, status: :accepted, vehicle: vehicle

    visit order_path(order)
    fill_in 'Latitude', with: '-90.1'
    fill_in 'Longitude', with: '180.1'
    fill_in 'Data e hora', with: 1.second.from_now
    click_on 'Atualizar rota de entrega'

    expect(page).to have_content 'Rota de entrega não atualizada.'
    expect(page).to have_content 'Latitude deve ser maior ou igual a -90'
    expect(page).to have_content 'Longitude deve ser menor ou igual a 180'
    expect(page).to have_content "Data e hora deve ser menor ou igual a #{Time.zone.now}"
  end

  it 'com data e hora anteriores à última atualização' do
    order = create :order, shipping_company: express, status: :accepted, vehicle: vehicle
    current_time = Time.current
    create :route_update, order: order, date_and_time: current_time

    visit order_path(order)
    fill_in 'Data e hora', with: 1.second.before(current_time)
    click_on 'Atualizar rota de entrega'

    expect(page).to have_content 'Rota de entrega não atualizada.'
    expect(page).to have_content 'Data e hora não podem ser anteriores à última atualização'
  end
end
