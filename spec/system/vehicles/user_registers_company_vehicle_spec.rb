require 'rails_helper'

describe 'Visitante cadastra veículo' do
  it 'com sucesso' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'
    find('div#vehicle_register_link').click_on 'Cadastrar veículo'
    within('form') do
      fill_in 'Placa de identificação', with: 'BRA3R52'
      fill_in 'Modelo', with: 'Uno'
      fill_in 'Marca', with: 'Fiat'
      fill_in 'Ano de produção', with: '1992'
      fill_in 'Carga máxima', with: '100000'
      click_on 'Criar Veículo'
    end

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

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'
    click_on 'Cadastrar veículo'
    fill_in 'Modelo', with: 'Uno'
    click_on 'Criar Veículo'

    expect(page).to have_content 'Veículo não cadastrado.'
    expect(page).to have_content 'Placa de identificação não é válido'
    expect(page).to have_content 'Marca não pode ficar em branco'
    expect(page).to have_content 'Ano de produção deve estar entre 1908 e o ano atual'
    expect(page).to have_content 'Carga máxima não pode ficar em branco'
    expect(page).to have_field 'Modelo', with: 'Uno'
  end

  it 'com dados inválidos ou repetidos' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: 1992,
                    maximum_load: 100_000, shipping_company: express)

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'
    click_on 'Cadastrar veículo'
    fill_in 'Placa de identificação', with: 'BRA3R52'
    fill_in 'Ano de produção', with: '2023'
    fill_in 'Carga máxima', with: '0'
    click_on 'Criar Veículo'

    expect(page).to have_content 'Placa de identificação já está em uso'
    expect(page).to have_content 'Ano de produção deve estar entre 1908 e o ano atual'
    expect(page).to have_content 'Carga máxima deve ser maior que 0'
  end
end
