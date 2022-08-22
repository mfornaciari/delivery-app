# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário cadastra veículo' do
  it 'sem se autenticar' do
    express = create :express

    visit new_shipping_company_vehicle_path(express)

    expect(page).to have_current_path new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    express = create :express
    user = create :user

    login_as user, scope: :user
    visit shipping_company_path(express)
    click_on 'Cadastrar veículo'
    fill_in 'Placa de identificação', with: 'BRA3R52'
    fill_in 'Modelo', with: 'Uno'
    fill_in 'Marca', with: 'Fiat'
    fill_in 'Ano de produção', with: '1992'
    fill_in 'Carga máxima', with: '100000'
    click_on 'Criar Veículo'

    expect(page).to have_current_path shipping_company_path(express)
    expect(page).to have_content 'Veículo cadastrado com sucesso.'
    expect(page).to have_content 'BRA3R52'
    expect(page).to have_content 'Fiat'
    expect(page).to have_content 'Uno'
    expect(page).to have_content '1992'
    expect(page).to have_content '100 kg'
  end

  it 'com dados incompletos' do
    express = create :express
    user = create :user

    login_as user, scope: :user
    visit new_shipping_company_vehicle_path(express)
    fill_in 'Modelo', with: 'Uno'
    click_on 'Criar Veículo'

    expect(page).to have_current_path shipping_company_vehicles_path(express)
    expect(page).to have_content 'Veículo não cadastrado.'
    expect(page).to have_field 'Modelo', with: 'Uno'
    expect(page).to have_content 'Placa de identificação não pode ficar em branco'
    expect(page).to have_content 'Marca não pode ficar em branco'
    expect(page).to have_content 'Ano de produção não pode ficar em branco'
    expect(page).to have_content 'Carga máxima não pode ficar em branco'
  end

  it 'com dados inválidos ou repetidos' do
    express = create :express
    user = create :user
    create :vehicle, shipping_company: express, license_plate: 'BRA3R52'

    login_as user, scope: :user
    visit new_shipping_company_vehicle_path(express)
    fill_in 'Placa de identificação', with: 'BRA3R52'
    fill_in 'Ano de produção', with: 1.year.from_now.year
    fill_in 'Carga máxima', with: '0'
    click_on 'Criar Veículo'

    expect(page).to have_current_path shipping_company_vehicles_path(express)
    expect(page).to have_content 'Placa de identificação já está em uso'
    expect(page).to have_content 'Ano de produção deve estar entre 1908 e o ano atual'
    expect(page).to have_content 'Carga máxima deve ser maior que 0'
  end
end
