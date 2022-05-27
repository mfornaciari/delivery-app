require 'rails_helper'

describe 'Usuário registra um novo intervalo de volume' do
  it 'sem se autenticar' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

    visit new_shipping_company_volume_range_path(1)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit shipping_company_path(1)
    click_on 'Cadastrar intervalo de volume'
    fill_in 'Volume mínimo', with: '0'
    fill_in 'Volume máximo', with: '50'
    fill_in 'Peso mínimo', with: '0'
    fill_in 'Peso máximo', with: '20'
    fill_in 'Valor', with: '50'
    click_on 'Criar Intervalo de volume'

    expect(page).to have_content 'Intervalo cadastrado com sucesso.'
    within_table('prices_table') do
      within('#0_50_1') do
        expect(page).to have_content '0-50 m3'
        expect(page).to have_content '0-20 kg'
        expect(page).to have_content 'R$ 0,50'
      end
    end
  end

  it 'com dados incompletos' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit new_shipping_company_volume_range_path(1)
    fill_in 'Volume mínimo', with: '0'
    click_on 'Criar Intervalo de volume'

    expect(page).to have_content 'Intervalo não cadastrado.'
    expect(page).to have_field 'Volume mínimo', with: '0'
    expect(page).to have_content 'Volume máximo não pode ficar em branco'
    expect(page).to have_content 'Peso mínimo não pode ficar em branco'
    expect(page).to have_content 'Peso máximo não pode ficar em branco'
    expect(page).to have_content 'Valor não pode ficar em branco'
  end

  it 'com dados inválidos' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    vrange = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 20)
    WeightRange.create!(volume_range: vrange, min_weight: 0, max_weight: 10, value: 25)
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit new_shipping_company_volume_range_path(1)
    fill_in 'Volume mínimo', with: '0'
    fill_in 'Volume máximo', with: '0'
    click_on 'Criar Intervalo de volume'

    expect(page).to have_content 'Volume mínimo não pode estar contido em intervalos já registrados'
    expect(page).to have_content 'Volume máximo deve ser maior que 0'
  end

  it 'com volume/peso mínimos >= volume/peso máximos' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit new_shipping_company_volume_range_path(1)
    fill_in 'Volume mínimo', with: '2'
    fill_in 'Volume máximo', with: '1'
    fill_in 'Peso mínimo', with: '2'
    fill_in 'Peso máximo', with: '2'
    click_on 'Criar Intervalo de volume'

    expect(page).to have_content 'Volume mínimo deve ser menor que o volume máximo'
    expect(page).to have_content 'Peso mínimo deve ser menor que o peso máximo'
  end
end
