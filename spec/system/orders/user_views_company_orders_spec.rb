require 'rails_helper'

describe 'Usuário vê pedidos da sua transportadora' do
  it 'sem se autenticar' do
    visit orders_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'e não há nenhum' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit shipping_company_path 1
    click_on 'Pedidos'

    expect(current_path).to eq orders_path
    expect(page).to have_content 'Pedidos de Express Transportes Ltda.'
    expect(page).to have_content 'Esta transportadora não recebeu nenhum pedido.'
    expect(page).to have_link 'Voltar'
  end

  it 'com sucesso' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345ABCDE')
    Order.create!(pickup_address: 'Rua Rio Vermelho, n. 10', pickup_city: 'Natal', pickup_state: 'RN',
                  delivery_address: 'Rua Rio Verde, n. 10', delivery_city: 'Aracaju', delivery_state: 'SE',
                  recipient_name: 'João da Silva', product_code: 'ABCD1234', volume: 5, weight: 10,
                  distance: 30, estimated_delivery_time: 2, value: 2500, shipping_company: express)
    allow(SecureRandom).to receive(:alphanumeric).and_return('12345ABCDE12345')
    Order.create!(pickup_address: 'Avenida Mar Vermelho, n. 10', pickup_city: 'Fortaleza', pickup_state: 'CE',
                  delivery_address: 'Avenida Mar Azul, n. 10', delivery_city: 'Goiânia', delivery_state: 'GO',
                  recipient_name: 'Maria dos Anjos', product_code: '1234ABCDE', volume: 10, weight: 30,
                  distance: 40, estimated_delivery_time: 4, value: 5000, shipping_company: express,
                  status: :accepted)

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
