require 'rails_helper'

describe 'Visitante acessa o índice de transportadoras' do
  it 'e vê as transportadoras cadastradas' do
    admin = Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    ShippingCompany.create!(brand_name: 'A Jato', corporate_name: 'A Jato S.A.',
                            email_domain: 'ajato.com', registration_number: 19_824_380_000_107,
                            address: 'Avenida B, 23', city: 'Natal', state: 'RN')

    visit root_path
    login_admin(admin)

    within_table('shipping_companies') do
      within('#table_header') do
        expect(page).to have_content 'Nome fantasia'
        expect(page).to have_content 'Razão social'
        expect(page).to have_content 'Domínio de e-mail'
        expect(page).to have_content 'CNPJ'
        expect(page).to have_content 'Endereço'
      end
      within('#Express') do
        expect(page).to have_content 'Express'
        expect(page).to have_content 'Express Transportes Ltda.'
        expect(page).to have_content 'express.com.br'
        expect(page).to have_content '28.891.540/0001-21'
        expect(page).to have_content 'Avenida A, 10 - Rio de Janeiro/RJ'
      end
      within('#A_Jato') do
        expect(page).to have_content 'A Jato'
        expect(page).to have_content 'A Jato S.A.'
        expect(page).to have_content 'ajato.com'
        expect(page).to have_content '19.824.380/0001-07'
        expect(page).to have_content 'Avenida B, 23 - Natal/RN'
      end
    end
  end

  it 'e não há transportadoras cadastradas' do
    admin = Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')

    visit root_path
    login_admin(admin)

    expect(page).to have_content 'Não existem transportadoras cadastradas.'
    expect(page).not_to have_table 'shipping_companies'
  end
end
