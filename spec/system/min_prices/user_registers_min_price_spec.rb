require 'rails_helper'

describe 'Usuário registra um novo intervalo de distância' do
  it 'com sucesso' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit root_path
    click_on 'Express'
    find('section#prices').click_on 'Cadastrar intervalo de distância'
    fill_in 'Distância mínima', with: '0'
    fill_in 'Distância máxima', with: '100'
    fill_in 'Valor', with: '5000'
    click_on 'Criar Intervalo de distância'

    expect(page).to have_content 'Intervalo cadastrado com sucesso.'
    within_table('min_prices_table') do
      expect(page).to have_content '0-100 km'
      expect(page).to have_content 'R$ 50,00'
    end
  end

  it 'com dados incompletos' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit root_path
    click_on 'Express'
    find('section#prices').click_on 'Cadastrar intervalo de distância'
    fill_in 'Distância mínima', with: '0'
    click_on 'Criar Intervalo de distância'

    expect(page).to have_content 'Intervalo não cadastrado.'
    expect(page).to have_field 'Distância mínima', with: '0'
    expect(page).to have_content 'Distância máxima não pode ficar em branco'
    expect(page).to have_content 'Valor não pode ficar em branco'
  end

  it 'com dados inválidos' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    PriceDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, value: 5000)
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit root_path
    click_on 'Express'
    find('section#prices').click_on 'Cadastrar intervalo de distância'
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
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit root_path
    click_on 'Express'
    find('section#prices').click_on 'Cadastrar intervalo de distância'
    fill_in 'Distância mínima', with: '10'
    fill_in 'Distância máxima', with: '5'
    click_on 'Criar Intervalo de distância'

    expect(page).to have_content 'Distância mínima deve ser menor que distância máxima'
  end
end
