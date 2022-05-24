require 'rails_helper'

describe 'Usuário edita intervalo de volume' do
  it 'e vê o formulário de edição' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    vrange = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 30)
    WeightRange.create!(volume_range: vrange, min_weight: 0, max_weight: 20, value: 50)
    WeightRange.create!(volume_range: vrange, min_weight: 21, max_weight: 40, value: 75)
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit root_path
    click_on 'Express'
    find('table#prices_table').find('#0_30_1').click_on 'Editar intervalo'

    expect(page).to have_content 'Editar intervalo de volume'
    expect(page).to have_field 'Volume mínimo', with: '0'
    expect(page).to have_field 'Volume máximo', with: '30'
    expect(page).to have_content 'Intervalo de peso 1'
    expect(page).to have_field 'Peso mínimo', with: '0'
    expect(page).to have_field 'Peso máximo', with: '20'
    expect(page).to have_field 'Valor', with: '50'
    expect(page).to have_content 'Intervalo de peso 2'
    expect(page).to have_field 'Peso mínimo', with: '21'
    expect(page).to have_field 'Peso máximo', with: '40'
    expect(page).to have_field 'Valor', with: '75'
    expect(page).to have_button 'Atualizar Intervalo de volume'
  end

  it 'com sucesso' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    vrange = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 30)
    WeightRange.create!(volume_range: vrange, min_weight: 0, max_weight: 20, value: 50)
    WeightRange.create!(volume_range: vrange, min_weight: 21, max_weight: 40, value: 75)
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit root_path
    click_on 'Express'
    click_on 'Editar intervalo'
    fill_in 'Volume mínimo', with: '10'
    fill_in 'Volume máximo', with: '40'
    within('section#weight_range_1') do
      fill_in 'Peso mínimo', with: '10'
      fill_in 'Peso máximo', with: '30'
      fill_in 'Valor', with: '60'
    end
    within('section#weight_range_2') do
      fill_in 'Peso mínimo', with: '31'
      fill_in 'Peso máximo', with: '60'
      fill_in 'Valor', with: '100'
    end
    click_on 'Atualizar Intervalo de volume'

    expect(page).to have_content 'Intervalo atualizado com sucesso.'
    within_table('prices_table') do
      within('#10_40_1') do
        expect(page).to have_content '10-40 m3'
        expect(page).to have_content '10-30 kg'
        expect(page).to have_content 'R$ 0,60'
      end
      within('#10_40_2') do
        expect(page).to have_content '31-60 kg'
        expect(page).to have_content 'R$ 1,00'
      end
    end
  end

  it 'com dados incompletos/inválidos' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    vrange = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 30)
    WeightRange.create!(volume_range: vrange, min_weight: 0, max_weight: 20, value: 50)
    WeightRange.create!(volume_range: vrange, min_weight: 21, max_weight: 40, value: 75)
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit root_path
    click_on 'Express'
    click_on 'Editar intervalo'
    fill_in 'Volume mínimo', with: ''
    fill_in 'Volume máximo', with: '0'
    within('section#weight_range_1') do
      fill_in 'Peso mínimo', with: '0'
      fill_in 'Peso máximo', with: '0'
      fill_in 'Valor', with: ''
    end
    click_on 'Atualizar Intervalo de volume'

    expect(page).to have_content 'Intervalo não atualizado.'
    expect(page).to have_content 'Volume mínimo não pode ficar em branco'
    expect(page).to have_content 'Volume máximo deve ser maior que 0'
    expect(page).to have_content 'Peso mínimo deve ser menor que o peso máximo'
    expect(page).to have_content 'Peso máximo deve ser maior que 0'
    expect(page).to have_content 'Valor não pode ficar em branco'
    expect(page).to have_field 'Peso máximo', with: '0'
    expect(page).to have_field 'Peso mínimo', with: '21'
  end

  it 'com dados repetidos' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    first_vrange = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 30)
    WeightRange.create!(volume_range: first_vrange, min_weight: 0, max_weight: 20, value: 50)
    WeightRange.create!(volume_range: first_vrange, min_weight: 21, max_weight: 40, value: 75)
    second_vrange = VolumeRange.create!(shipping_company: express, min_volume: 31, max_volume: 60)
    WeightRange.create!(volume_range: second_vrange, min_weight: 0, max_weight: 20, value: 75)
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit root_path
    click_on 'Express'
    find('#0_30_1').click_on 'Editar intervalo'
    fill_in 'Volume mínimo', with: '31'
    fill_in 'Volume máximo', with: '40'
    within('section#weight_range_1') do
      fill_in 'Peso mínimo', with: '41'
      fill_in 'Peso máximo', with: '60'
    end
    within('section#weight_range_2') do
      fill_in 'Peso mínimo', with: '45'
      fill_in 'Peso máximo', with: '55'
    end
    click_on 'Atualizar Intervalo de volume'

    expect(page).to have_content 'Volume mínimo não pode estar contido em intervalos já registrados'
    expect(page).to have_content 'Volume máximo não pode estar contido em intervalos já registrados'
    within('section#weight_range_2') do
      expect(page).to have_content 'Peso mínimo não pode estar contido em intervalos já registrados'
      expect(page).to have_content 'Peso máximo não pode estar contido em intervalos já registrados'
    end
  end
end
