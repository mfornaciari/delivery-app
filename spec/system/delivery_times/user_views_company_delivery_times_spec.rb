require 'rails_helper'

describe 'Usuário vê tabela de prazos da transportadora' do
  it 'e não há intervalos de distância cadastrados' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'

    expect(page).to have_content 'Tabela de prazos'
    within('section#delivery_times') do
      expect(page).to have_link 'Cadastrar intervalo de distância'
      expect(page).to have_content 'Não existem intervalos de distância cadastrados.'
    end
  end

  it 'e vê intervalos de distância' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    TimeDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2)
    TimeDistanceRange.create!(shipping_company: express, min_distance: 101, max_distance: 200, delivery_time: 3)

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'

    within('section#delivery_times') do
      expect(page).not_to have_content 'Não existem intervalos de distância cadastrados.'
      within_table('delivery_times_table') do
        within('#table_header') do
          expect(page).to have_content 'Distância'
          expect(page).to have_content 'Prazo'
        end
        within('#0_100') do
          expect(page).to have_content '0-100 km'
          expect(page).to have_content '2 dias'
        end
        within('#101_200') do
          expect(page).to have_content '101-200 km'
          expect(page).to have_content '3 dias'
        end
      end
    end
  end
end
