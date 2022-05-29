require 'rails_helper'

describe 'Administrador vê as buscas de preço realizadas' do
  it 'na página inicial' do
    admin = Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')
    other_admin = Admin.create!(email: 'other@sistemadefrete.com.br', password: 'password')
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    TimeDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, delivery_time: 2)
    TimeDistanceRange.create!(shipping_company: express, min_distance: 101, max_distance: 200, delivery_time: 3)
    PriceDistanceRange.create!(shipping_company: express, min_distance: 0, max_distance: 100, value: 500)
    first_express_volume_range = VolumeRange.create!(shipping_company: express, min_volume: 0, max_volume: 50)
    second_express_volume_range = VolumeRange.create!(shipping_company: express, min_volume: 51, max_volume: 100)
    WeightRange.create!(volume_range: first_express_volume_range, min_weight: 1, max_weight: 20, value: 50)
    WeightRange.create!(volume_range: second_express_volume_range, min_weight: 1, max_weight: 10, value: 75)
    WeightRange.create!(volume_range: second_express_volume_range, min_weight: 11, max_weight: 20, value: 100)
    a_jato = ShippingCompany.create!(brand_name: 'A Jato', corporate_name: 'A Jato S.A.',
                                     email_domain: 'ajato.com', registration_number: 19_824_380_000_107,
                                     address: 'Avenida B, 23', city: 'Natal', state: 'RN')
    TimeDistanceRange.create!(shipping_company: a_jato, min_distance: 0, max_distance: 100, delivery_time: 3)
    TimeDistanceRange.create!(shipping_company: a_jato, min_distance: 101, max_distance: 200, delivery_time: 4)
    PriceDistanceRange.create!(shipping_company: a_jato, min_distance: 0, max_distance: 100, value: 5_000)
    a_jato_volume_range = VolumeRange.create!(shipping_company: a_jato, min_volume: 0, max_volume: 100)
    WeightRange.create!(volume_range: a_jato_volume_range, min_weight: 1, max_weight: 5, value: 50)
    BudgetSearch.create!(height: 100, width: 100, depth: 100, weight: 5, distance: 50, admin:)
    BudgetSearch.create!(height: 1_000, width: 1_000, depth: 1_000, weight: 500, distance: 500,
                         admin: other_admin)

    login_as admin, scope: :admin
    visit root_path

    expect(page).not_to have_content 'Não há buscas de orçamento registradas.'
    expect(page).to have_content 'Buscas realizadas:'
    within_table('budget_searches') do
      within('#table_header') do
        expect(page).to have_content 'No. da busca'
        expect(page).to have_content 'Data'
        expect(page).to have_content 'Administrador'
      end
      within('#1') do
        expect(page).to have_content '1'
        expect(page).to have_content I18n.l(Date.current)
        expect(page).to have_content 'admin@sistemadefrete.com.br'
      end
      within('#2') do
        expect(page).to have_content '2'
        expect(page).to have_content I18n.l(Date.current)
        expect(page).to have_content 'other@sistemadefrete.com.br'
      end
    end
  end

  it 'e não há nenhuma' do
    admin = Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')

    login_as admin, scope: :admin
    visit root_path

    expect(page).to have_content 'Não há buscas de orçamento registradas.'
  end

  it 'e acessa os detalhes de uma' do
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
    visit root_path
    click_on '1'

    expect(current_path).to eq budget_search_path(1)
  end
end
