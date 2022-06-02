# frozen_string_literal: true

require 'rails_helper'

describe 'Administrador cria um novo pedido' do
  it 'a partir de uma busca de preços' do
    admin = Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    TimeDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2)
    PriceDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, value: 500)
    volume_range = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 50)
    WeightRange.create!(volume_range:, min_weight: 0, max_weight: 20, value: 50)
    a_jato = ShippingCompany.create!(brand_name: 'A Jato', corporate_name: 'A Jato S.A.',
                                     email_domain: 'ajato.com', registration_number: 19_824_380_000_107,
                                     address: 'Avenida B, 23', city: 'Natal', state: 'RN')
    TimeDistanceRange.create!(shipping_company: a_jato, min_distance: 0, max_distance: 100, delivery_time: 3)
    PriceDistanceRange.create!(shipping_company: a_jato, min_distance: 0, max_distance: 100, value: 5_000)
    a_jato_volume_range = VolumeRange.create!(shipping_company: a_jato, min_volume: 0, max_volume: 100)
    WeightRange.create!(volume_range: a_jato_volume_range, min_weight: 1, max_weight: 5, value: 50)
    BudgetSearch.create!(height: 100, width: 100, depth: 100, weight: 5, distance: 50, admin:)

    login_as admin, scope: :admin
    visit budget_search_path 1
    find('#express').click_on 'Enviar pedido'

    expect(page).to have_content 'Enviando pedido para Express Transportes Ltda.'
    expect(page).to have_content 'Volume: 1 m³'
    expect(page).to have_content 'Peso: 5 kg'
    expect(page).to have_content 'Distância a percorrer: 50 km'
    expect(page).to have_content 'Tempo de entrega previsto: 2 dias'
    expect(page).to have_content 'Valor: R$ 25,00'
    within('#pickup_address') do
      expect(page).to have_content 'Retirada:'
      expect(page).to have_field 'Endereço de retirada'
      expect(page).to have_field 'Cidade de retirada'
      expect(page).to have_field 'Estado de retirada'
    end
    within('#delivery_address') do
      expect(page).to have_content 'Entrega:'
      expect(page).to have_field 'Endereço de entrega'
      expect(page).to have_field 'Cidade de entrega'
      expect(page).to have_field 'Estado de entrega'
    end
    expect(page).to have_field 'Destinado a'
    expect(page).to have_field 'Código do produto a transportar'
    expect(page).to have_button 'Enviar pedido'
  end

  it 'sem realizar busca' do
    admin = Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    TimeDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2)
    PriceDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, value: 500)
    volume_range = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 50)
    WeightRange.create!(volume_range:, min_weight: 0, max_weight: 20, value: 50)
    BudgetSearch.create!(height: 100, width: 100, depth: 100, weight: 5, distance: 50, admin:)

    login_as admin, scope: :admin
    visit new_order_path

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Crie um pedido a partir de uma consulta de preços.'
  end

  it 'com sucesso' do
    admin = Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    TimeDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2)
    PriceDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, value: 500)
    volume_range = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 50)
    WeightRange.create!(volume_range:, min_weight: 0, max_weight: 20, value: 50)
    BudgetSearch.create!(height: 100, width: 100, depth: 100, weight: 5, distance: 50, admin:)
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345ABCDE')

    login_as admin, scope: :admin
    visit budget_search_path 1
    find('#express').click_on 'Enviar pedido'
    fill_in 'Endereço de retirada', with: 'Rua Rio Vermelho, n. 10'
    fill_in 'Cidade de retirada', with: 'Natal'
    select 'RN', from: 'Estado de retirada'
    fill_in 'Endereço de entrega', with: 'Rua Rio Verde, n. 10'
    fill_in 'Cidade de entrega', with: 'Aracaju'
    select 'SE', from: 'Estado de entrega'
    fill_in 'Destinado a', with: 'João da Silva'
    fill_in 'Código do produto a transportar', with: 'ABCD1234'
    click_on 'Enviar pedido'

    expect(page).to have_current_path order_path 1
    expect(page).to have_content 'Pedido cadastrado com sucesso.'
    expect(page).to have_content 'Pedido ABCDE12345ABCDE'
    expect(page).to have_content 'Transportadora: Express Transportes Ltda.'
    expect(page).to have_content 'Volume: 1 m³'
    expect(page).to have_content 'Peso: 5 kg'
    expect(page).to have_content 'Distância a percorrer: 50 km'
    expect(page).to have_content 'Endereço de retirada: Rua Rio Vermelho, n. 10 - Natal/RN'
    expect(page).to have_content 'Endereço de entrega: Rua Rio Verde, n. 10 - Aracaju/SE'
    expect(page).to have_content 'Destinado a: João da Silva'
    expect(page).to have_content 'Código do produto: ABCD1234'
    expect(page).to have_content 'Tempo de entrega previsto: 2 dias'
    expect(page).to have_content 'Valor: R$ 25,00'
    expect(page).to have_content 'Status: Pendente'
  end

  it 'com dados incompletos' do
    admin = Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    TimeDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2)
    PriceDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, value: 500)
    volume_range = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 50)
    WeightRange.create!(volume_range:, min_weight: 0, max_weight: 20, value: 50)
    BudgetSearch.create!(height: 100, width: 100, depth: 100, weight: 5, distance: 50, admin:)
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345ABCDE')

    login_as admin, scope: :admin
    visit budget_search_path 1
    find('#express').click_on 'Enviar pedido'
    click_on 'Enviar pedido'

    expect(page).to have_content 'Pedido não cadastrado.'
    expect(page).to have_content 'Endereço de retirada não pode ficar em branco'
    expect(page).to have_content 'Cidade de retirada não pode ficar em branco'
    expect(page).to have_content 'Estado de retirada não pode ficar em branco'
    expect(page).to have_content 'Endereço de entrega não pode ficar em branco'
    expect(page).to have_content 'Cidade de entrega não pode ficar em branco'
    expect(page).to have_content 'Estado de entrega não pode ficar em branco'
    expect(page).to have_content 'Nome(a) do destinatário(a) não pode ficar em branco'
    expect(page).to have_content 'Código do produto não pode ficar em branco'
  end
end
