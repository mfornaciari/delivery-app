require 'rails_helper'

describe 'Usuário registra um novo intervalo de peso' do
  it 'com sucesso' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    vrange = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 30)
    WeightRange.create!(volume_range: vrange, min_weight: 0, max_weight: 20, value: 50)

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'
    click_on 'Editar intervalo'
    click_on 'Cadastrar intervalo de peso'
    fill_in 'Peso mínimo', with: '21'
    fill_in 'Peso máximo', with: '40'
    fill_in 'Valor', with: '75'
    click_on 'Criar Intervalo de peso'

    expect(page).to have_content 'Intervalo cadastrado com sucesso.'
    expect(page).to have_field 'Peso mínimo', with: '21'
    expect(page).to have_field 'Peso máximo', with: '40'
    expect(page).to have_field 'Valor', with: '75'
  end

  it 'com dados incompletos' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    vrange = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 30)
    WeightRange.create!(volume_range: vrange, min_weight: 0, max_weight: 20, value: 50)

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'
    click_on 'Editar intervalo'
    click_on 'Cadastrar intervalo de peso'
    fill_in 'Peso mínimo', with: '21'
    click_on 'Criar Intervalo de peso'

    expect(page).to have_content 'Intervalo não cadastrado.'
    expect(page).to have_field 'Peso mínimo', with: '21'
    expect(page).to have_content 'Peso máximo não pode ficar em branco'
    expect(page).to have_content 'Valor não pode ficar em branco'
  end

  it 'com dados inválidos' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    vrange = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 30)
    WeightRange.create!(volume_range: vrange, min_weight: 0, max_weight: 20, value: 50)

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'
    click_on 'Editar intervalo'
    click_on 'Cadastrar intervalo de peso'
    fill_in 'Peso mínimo', with: '0'
    fill_in 'Peso máximo', with: '0'
    click_on 'Criar Intervalo de peso'

    expect(page).to have_content 'Peso mínimo não pode estar contido em intervalos já registrados'
    expect(page).to have_content 'Peso máximo deve ser maior que 0'
  end

  it 'com peso mínimo >= peso máximo' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    vrange = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 30)
    WeightRange.create!(volume_range: vrange, min_weight: 0, max_weight: 20, value: 50)

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'
    click_on 'Editar intervalo'
    click_on 'Cadastrar intervalo de peso'
    fill_in 'Peso mínimo', with: '30'
    fill_in 'Peso máximo', with: '21'
    click_on 'Criar Intervalo de peso'

    expect(page).to have_content 'Peso mínimo deve ser menor que o peso máximo'
  end
end
