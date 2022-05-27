require 'rails_helper'

describe 'Usuário acessa a tela de detalhes da sua transportadora' do
  it 'sem se autenticar' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

    visit shipping_company_path(1)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'e vê detalhes completos' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit root_path
    click_on 'Express'

    within('div#page_title') do
      expect(page).to have_content 'Express'
    end
    within('section#company_details') do
      expect(page).to have_content 'Nome fantasia: Express'
      expect(page).to have_content 'Razão social: Express Transportes Ltda.'
      expect(page).to have_content 'CNPJ: 28.891.540/0001-21'
      expect(page).to have_content 'Domínio de e-mail: express.com.br'
      expect(page).to have_content 'Endereço: Avenida A, 10 - Rio de Janeiro/RJ'
    end
  end

  it 'e volta para a tela inicial' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    login_as user, scope: :user
    visit shipping_company_path(1)
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end
