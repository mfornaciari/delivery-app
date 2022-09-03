# frozen_string_literal: true

require 'rails_helper'

describe 'Administrador cria um novo pedido' do
  let(:admin) { create :admin }

  before { login_as admin, scope: :admin }

  it 'sem realizar busca antes' do
    visit new_order_path

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Crie um pedido a partir de uma consulta de preços.'
  end

  it 'a partir de uma busca de preços' do
    express = create :express, corporate_name: 'Express Transportes Ltda.'
    create :time_distance_range, shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2
    create :price_distance_range, shipping_company: express, min_distance: 0, max_distance: 100, value: 500
    express_volume_range = create :volume_range, shipping_company: express, min_volume: 0, max_volume: 50
    create :weight_range, volume_range: express_volume_range, min_weight: 0, max_weight: 20, value: 50
    a_jato = create :a_jato
    create :time_distance_range, shipping_company: a_jato
    create :price_distance_range, shipping_company: a_jato
    a_jato_volume_range = create :volume_range, shipping_company: a_jato
    create :weight_range, volume_range: a_jato_volume_range
    search = create :budget_search, height: 100, width: 100, depth: 100, weight: 5, distance: 50, admin: admin

    visit budget_search_path(search)
    find('#express').click_on 'Enviar pedido'

    expect(page).to have_content 'Enviando pedido para Express Transportes Ltda.'
    expect(page).to have_content 'Volume: 1 m³'
    expect(page).to have_content 'Peso: 5 kg'
    expect(page).to have_content 'Distância a percorrer: 50 km'
    expect(page).to have_content 'Tempo de entrega previsto: 2 dias'
    expect(page).to have_content 'Valor: R$ 25,00'
    within('#pickup_address') do
      expect(page).to have_content 'Retirada:'
      expect(page).to have_field 'Endereço'
      expect(page).to have_field 'Cidade'
      expect(page).to have_field 'Estado'
    end
    within('#delivery_address') do
      expect(page).to have_content 'Entrega:'
      expect(page).to have_field 'Endereço'
      expect(page).to have_field 'Cidade'
      expect(page).to have_field 'Estado'
    end
    expect(page).to have_field 'Destinado a'
    expect(page).to have_field 'Código do produto a transportar'
    expect(page).to have_button 'Enviar pedido'
  end

  it 'com sucesso' do
    express = create :express
    create :time_distance_range, shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2
    create :price_distance_range, shipping_company: express, min_distance: 0, max_distance: 100, value: 500
    volume_range = create :volume_range, shipping_company: express, min_volume: 0, max_volume: 50
    create :weight_range, volume_range: volume_range, min_weight: 0, max_weight: 20, value: 50
    search = create :budget_search, height: 100, width: 100, depth: 100, weight: 5, distance: 50, admin: admin
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345ABCDE')

    visit budget_search_path(search)
    find('#express').click_on 'Enviar pedido'
    within('#pickup_address') do
      fill_in 'Endereço', with: 'Rua Rio Vermelho, n. 10'
      fill_in 'Cidade', with: 'Natal'
      select 'RN', from: 'Estado'
    end
    within('#delivery_address') do
      fill_in 'Endereço', with: 'Rua Rio Verde, n. 10'
      fill_in 'Cidade', with: 'Aracaju'
      select 'SE', from: 'Estado'
    end
    fill_in 'Destinado a', with: 'João da Silva'
    fill_in 'Código do produto a transportar', with: 'ABCD1234'
    click_on 'Enviar pedido'

    expect(page).to have_current_path order_path(Order.last)
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
    express = create :express
    create :time_distance_range, shipping_company: express
    create :price_distance_range, shipping_company: express
    volume_range = create :volume_range, shipping_company: express
    create :weight_range, volume_range: volume_range
    search = create :budget_search, admin: admin

    visit budget_search_path(search)
    find('#express').click_on 'Enviar pedido'
    click_on 'Enviar pedido'

    expect(page).to have_content 'Pedido não cadastrado.'
    within('#pickup_address') do
      expect(page).to have_content 'Endereço não pode ficar em branco'
      expect(page).to have_content 'Cidade não pode ficar em branco'
    end
    within('#delivery_address') do
      expect(page).to have_content 'Endereço não pode ficar em branco'
      expect(page).to have_content 'Cidade não pode ficar em branco'
    end
    expect(page).to have_content 'Nome(a) do(a) destinatário(a) não pode ficar em branco'
    expect(page).to have_content 'Código do produto não pode ficar em branco'
  end
end
