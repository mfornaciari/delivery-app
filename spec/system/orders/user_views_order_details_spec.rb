# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário visualiza detalhes de um pedido' do
  let!(:express) { create :express }
  let!(:order) { create :order, shipping_company: express }

  it 'sem estar autenticado' do
    visit order_path(order)

    expect(page).to have_current_path new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    user = create :user, email: 'user@express.com.br'

    login_as user, scope: :user
    visit shipping_company_path(express)
    click_on 'Pedidos'
    click_on order.code

    expect(page).to have_current_path order_path(order)
  end
end
