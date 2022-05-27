require 'rails_helper'

describe 'Usuário cadastra veículo' do
  it 'sem se autenticar' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

    visit new_shipping_company_vehicle_path(1)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as(user)
    visit shipping_company_path(1)
    click_on 'Cadastrar veículo'
    fill_in 'Placa de identificação', with: 'BRA3R52'
    fill_in 'Modelo', with: 'Uno'
    fill_in 'Marca', with: 'Fiat'
    fill_in 'Ano de produção', with: '1992'
    fill_in 'Carga máxima', with: '100000'
    click_on 'Criar Veículo'

    expect(page).to have_content 'Veículo cadastrado com sucesso.'
    expect(page).to have_content 'BRA3R52'
    expect(page).to have_content 'Fiat'
    expect(page).to have_content 'Uno'
    expect(page).to have_content '1992'
    expect(page).to have_content '100 kg'
  end

  it 'com dados incompletos' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as(user, scope: :user)
    visit new_shipping_company_vehicle_path(1)
    fill_in 'Modelo', with: 'Uno'
    click_on 'Criar Veículo'

    expect(page).to have_content 'Veículo não cadastrado.'
    expect(page).to have_content 'Placa de identificação não é válido'
    expect(page).to have_content 'Marca não pode ficar em branco'
    expect(page).to have_content 'Ano de produção não pode ficar em branco'
    expect(page).to have_content 'Carga máxima não pode ficar em branco'
    expect(page).to have_field 'Modelo', with: 'Uno'
  end

  it 'com dados inválidos ou repetidos' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                    maximum_load: 100_000, shipping_company: express)
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as(user, scope: :user)
    visit new_shipping_company_vehicle_path(1)
    fill_in 'Placa de identificação', with: 'BRA3R52'
    fill_in 'Ano de produção', with: '2023'
    fill_in 'Carga máxima', with: '0'
    click_on 'Criar Veículo'

    expect(page).to have_content 'Placa de identificação já está em uso'
    expect(page).to have_content 'Ano de produção deve estar entre 1908 e o ano atual'
    expect(page).to have_content 'Carga máxima deve ser maior que 0'
  end
end
