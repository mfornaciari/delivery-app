require 'rails_helper'

describe 'Usuário registra um novo intervalo de distância' do
  it 'com sucesso' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'
    find('section#delivery_times').click_on 'Cadastrar intervalo de distância'
    fill_in 'Distância mínima', with: '0'
    fill_in 'Distância máxima', with: '100'
    fill_in 'Prazo', with: '2'
    click_on 'Criar Intervalo de distância'

    expect(page).to have_content 'Intervalo cadastrado com sucesso.'
    within_table('delivery_times_table') do
      expect(page).to have_content '0-100 km'
      expect(page).to have_content '2 dias'
    end
  end

  it 'com dados incompletos' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'
    find('section#delivery_times').click_on 'Cadastrar intervalo de distância'
    fill_in 'Distância mínima', with: '0'
    click_on 'Criar Intervalo de distância'

    expect(page).to have_content 'Intervalo não cadastrado.'
    expect(page).to have_field 'Distância mínima', with: '0'
    expect(page).to have_content 'Distância máxima não pode ficar em branco'
    expect(page).to have_content 'Prazo não pode ficar em branco'
  end

  it 'com dados inválidos' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    TimeDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2)

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'
    find('section#delivery_times').click_on 'Cadastrar intervalo de distância'
    fill_in 'Distância mínima', with: '0'
    fill_in 'Distância máxima', with: '0'
    click_on 'Criar Intervalo de distância'

    expect(page).to have_content 'Distância mínima não pode estar contida em intervalos já registrados'
    expect(page).to have_content 'Distância máxima deve ser maior que 0'
  end

  it 'com distância mínima >= distância máxima' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'
    find('section#delivery_times').click_on 'Cadastrar intervalo de distância'
    fill_in 'Distância mínima', with: '10'
    fill_in 'Distância máxima', with: '5'
    click_on 'Criar Intervalo de distância'

    expect(page).to have_content 'Distância mínima deve ser menor que distância máxima'
  end
end
