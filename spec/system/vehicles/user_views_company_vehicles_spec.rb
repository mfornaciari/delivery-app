require 'rails_helper'

describe 'Usuário acessa a página de detalhes de uma transportadora' do
  it 'e vê os veículos cadastrados' do
    express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    Vehicle.create!(license_plate: 'BRA3R52', brand: 'Fiat', model: 'Uno', production_year: '1992',
                    maximum_load: 100_000, shipping_company: express)
    Vehicle.create!(license_plate: 'ARG4523', brand: 'Volkswagen', model: 'Fusca', production_year: '1971',
                    maximum_load: 40_000, shipping_company: express)

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'

    expect(page).to have_content 'Veículos cadastrados'
    within_table('vehicles') do
      within('#table_header') do
        expect(page).to have_content 'Placa de identificação'
        expect(page).to have_content 'Modelo'
        expect(page).to have_content 'Marca'
        expect(page).to have_content 'Ano de produção'
        expect(page).to have_content 'Carga máxima'
      end
      within('#BRA3R52') do
        expect(page).to have_content 'BRA3R52'
        expect(page).to have_content 'Fiat'
        expect(page).to have_content 'Uno'
        expect(page).to have_content '1992'
        expect(page).to have_content '100 kg'
      end
      within('#ARG4523') do
        expect(page).to have_content 'ARG4523'
        expect(page).to have_content 'Volkswagen'
        expect(page).to have_content 'Fusca'
        expect(page).to have_content '1971'
        expect(page).to have_content '40 kg'
      end
    end
  end

  it 'e não há veículos cadastrados' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

    visit root_path
    click_on 'Transportadoras'
    click_on 'Express'

    expect(page).to have_content 'Não existem veículos cadastrados.'
  end
end
