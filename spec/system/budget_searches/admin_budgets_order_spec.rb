require 'rails_helper'

describe 'Administrador consulta preço de pedido' do
  it 'a partir do menu de navegação' do
    admin = Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')

    login_as(admin, scope: :admin)
    visit root_path
    find('nav').click_on 'Consultar preços'

    expect(page).to have_content 'Consulta de preços de transporte'
    expect(page).to have_content 'Dimensões do item (em centímetros):'
    expect(page).to have_field 'Altura'
    expect(page).to have_field 'Largura'
    expect(page).to have_field 'Profundidade'
    expect(page).to have_field 'Peso do item (em quilogramas)'
    expect(page).to have_field 'Distância a percorrer (em quilômetros)'
    expect(page).to have_button 'Consultar'
  end

  it 'sem se autenticar' do
    visit new_budget_search_path

    expect(current_path).to eq new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    admin = Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    TimeDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2)
    TimeDistanceRange.create!(shipping_company: express, min_distance: 101, max_distance: 200, delivery_time: 3)
    PriceDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, value: 500)
    first_express_volume_range = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 50)
    second_express_volume_range = VolumeRange.create!(shipping_company: express, min_volume: 51, max_volume: 100)
    WeightRange.create!(volume_range: first_express_volume_range, min_weight: 1, max_weight: 20, value: 50)
    WeightRange.create!(volume_range: second_express_volume_range, min_weight: 1, max_weight: 10, value: 75)
    WeightRange.create!(volume_range: second_express_volume_range, min_weight: 11, max_weight: 20, value: 100)
    a_jato = ShippingCompany.create!(brand_name: 'A Jato', corporate_name: 'A Jato S.A.',
                                     email_domain: 'ajato.com', registration_number: 19_824_380_000_107,
                                     address: 'Avenida B, 23', city: 'Natal', state: 'RN')
    TimeDistanceRange.create!(shipping_company: a_jato, min_distance: 0, max_distance: 100, delivery_time: 3)
    TimeDistanceRange.create!(shipping_company: a_jato, min_distance: 101, max_distance: 200, delivery_time: 4)
    PriceDistanceRange.create!(shipping_company: a_jato, min_distance: 0, max_distance: 100, value: 5_000)
    a_jato_volume_range = VolumeRange.create!(shipping_company: a_jato, min_volume: 0, max_volume: 100)
    WeightRange.create!(volume_range: a_jato_volume_range, min_weight: 1, max_weight: 5, value: 50)

    login_as(admin, scope: :admin)
    visit new_budget_search_path
    fill_in 'Altura', with: 100
    fill_in 'Largura', with: 100
    fill_in 'Profundidade', with: 100
    fill_in 'Peso do item (em quilogramas)', with: 5
    fill_in 'Distância a percorrer (em quilômetros)', with: 20
    click_on 'Consultar'

    expect(page).to have_content 'Resultado da sua busca:'
    expect(page).to have_content "Busca no. 1 (#{I18n.l(Date.current)})"
    expect(page).to have_content "Realizada por: #{admin.email}"
    expect(page).to have_content 'Volume: 1 m³'
    expect(page).to have_content 'Peso: 5 kg'
    expect(page).to have_content 'Distância a percorrer: 20 km'
    within_table('search_details') do
      within('#table_header') do
        expect(page).to have_content 'Transportadora'
        expect(page).to have_content 'Valor'
        expect(page).to have_content 'Prazo'
      end
      within('#express') do
        expect(page).to have_content 'Express'
        expect(page).to have_content 'R$ 10,00'
        expect(page).to have_content '2 dias'
      end
      within('#a_jato') do
        expect(page).to have_content 'A Jato'
        expect(page).to have_content 'R$ 50,00'
        expect(page).to have_content '3 dias'
      end
    end
  end
end
