require 'rails_helper'

describe 'Usuário de transportadora se autentica' do
  it 'com sucesso' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    visit root_path
    login_user(user)

    expect(current_path).to eq shipping_company_path(1)
    expect(page).to have_content 'Login efetuado com sucesso'
    expect(page).to have_content 'usuario@express.com.br'
    expect(page).to have_button 'Sair'
    expect(page).to have_link 'Express'
    expect(page).not_to have_link 'Transportadoras'
  end

  it 'e faz logout' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
    user = User.create!(email: 'usuario@express.com.br', password: 'password')

    visit root_path
    login_user(user)
    click_on 'Sair'

    expect(current_path).to eq root_path
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
  end
end
