require 'rails_helper'

describe 'Usuário vê tabela de preços mínimos da transportadora' do
  it 'e não há intervalos de distância cadastrados' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit shipping_company_path(1)

    within('section#prices') do
      expect(page).to have_content 'Preços mínimos por distância'
      expect(page).to have_link 'Cadastrar intervalo de distância'
      expect(page).to have_content 'Não existem intervalos de distância cadastrados.'
    end
  end

  it 'e vê intervalos de distância' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    PriceDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, value: 5000)
    PriceDistanceRange.create!(shipping_company: express, min_distance: 101, max_distance: 200, value: 10000)
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit shipping_company_path(1)

    within('section#prices') do
      expect(page).not_to have_content 'Não existem intervalos de distância cadastrados.'
    end
    within_table('min_prices_table') do
      within('#table_header') do
        expect(page).to have_content 'Distância'
        expect(page).to have_content 'Valor mínimo'
      end
      within('#0_100') do
        expect(page).to have_content '0-100 km'
        expect(page).to have_content 'R$ 50,00'
      end
      within('#101_200') do
        expect(page).to have_content '101-200 km'
        expect(page).to have_content 'R$ 100,00'
      end
    end
  end
end
