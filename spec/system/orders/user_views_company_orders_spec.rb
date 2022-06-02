# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário vê pedidos da sua transportadora' do
  it 'sem se autenticar' do
    visit orders_path

    expect(page).to have_current_path new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'e não há nenhum' do
    create :express, email_domain: 'express.com.br'
    user = create :user, email: 'usuario@express.com.br'

    login_as user, scope: :user
    visit shipping_company_path 1
    click_on 'Pedidos'

    expect(page).to have_content 'Pedidos de Express Transportes Ltda.'
    expect(page).to have_content 'Esta transportadora não recebeu nenhum pedido.'
    expect(page).to have_link 'Voltar'
  end

  it 'com sucesso' do
    express = create :express, email_domain: 'express.com.br'
    vehicle = create :vehicle, shipping_company: express
    user = create :user, email: 'usuario@express.com.br'
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345ABCDE')
    create :order, shipping_company: express, estimated_delivery_time: 2, value: 2_500
    allow(SecureRandom).to receive(:alphanumeric).and_return('12345ABCDE12345')
    create :order, shipping_company: express, estimated_delivery_time: 4, value: 5_000, status: :accepted,
                   vehicle: vehicle

    login_as user, scope: :user
    visit shipping_company_path 1
    click_on 'Pedidos'

    within_table('orders') do
      within('#table_header') do
        expect(page).to have_content 'Código'
        expect(page).to have_content 'Data de criação'
        expect(page).to have_content 'Tempo de entrega previsto'
        expect(page).to have_content 'Valor'
        expect(page).to have_content 'Status'
      end
      within('#ABCDE12345ABCDE') do
        expect(page).to have_link 'ABCDE12345ABCDE'
        expect(page).to have_content I18n.l(Date.current)
        expect(page).to have_content '2 dias'
        expect(page).to have_content 'R$ 25,00'
        expect(page).to have_content 'Pendente'
      end
      within('#12345ABCDE12345') do
        expect(page).to have_link '12345ABCDE12345'
        expect(page).to have_content I18n.l(Date.current)
        expect(page).to have_content '4 dias'
        expect(page).to have_content 'R$ 50,00'
        expect(page).to have_content 'Aceito'
      end
    end
  end
end
