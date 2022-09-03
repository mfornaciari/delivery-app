# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário atualiza o status de um pedido' do
  let!(:express) { create :express }
  let(:user) { create :user }

  before { login_as user, scope: :user }

  context 'e aceita-o' do
    it 'com sucesso' do
      create :vehicle, shipping_company: express,
                       license_plate: 'BRA3R52'
      create :vehicle, shipping_company: express,
                       license_plate: 'ARG4523'
      order = create :order, shipping_company: express,
                             status: :pending

      visit shipping_company_path(express)
      click_on 'Pedidos'
      click_on order.code
      select 'ARG4523', from: 'Veículo responsável'
      click_on 'Aceitar pedido'

      expect(page).to have_current_path order_path(order)
      expect(page).to have_content 'Pedido aceito.'
      expect(page).to have_content 'Status: Aceito'
      expect(page).to have_content 'Veículo responsável: ARG4523'
    end

    it 'sem escolher veículo' do
      create :vehicle, shipping_company: express
      order = create :order, shipping_company: express,
                             status: :pending

      visit shipping_company_path(express)
      click_on 'Pedidos'
      click_on order.code
      click_on 'Aceitar pedido'

      expect(page).to have_current_path order_path(order)
      expect(page).to have_content 'Status não atualizado: atribua o pedido a um veículo.'
      within('#order_details') do
        expect(page).not_to have_content 'Veículo responsável'
        expect(page).not_to have_content 'Status: Aceito'
      end
    end
  end

  it 'e rejeita-o' do
    order = create :order, shipping_company: express,
                           status: :pending

    visit shipping_company_path(express)
    click_on 'Pedidos'
    click_on order.code
    click_on 'Rejeitar pedido'

    expect(page).to have_content 'Pedido rejeitado.'
    expect(page).to have_content 'Status: Rejeitado'
    expect(page).not_to have_select 'Veículo responsável'
    expect(page).not_to have_button 'Aceitar pedido'
  end

  it 'e finaliza-o' do
    vehicle = create :vehicle, shipping_company: express
    order = create :order, shipping_company: express,
                           status: :accepted,
                           vehicle: vehicle

    visit shipping_company_path(express)
    click_on 'Pedidos'
    click_on order.code
    click_on 'Finalizar pedido'

    expect(page).to have_content 'Pedido finalizado.'
    expect(page).to have_content 'Status: Finalizado'
    expect(page).not_to have_button 'Finalizar pedido'
    expect(page).not_to have_button 'Atualizar rota de entrega'
  end
end
