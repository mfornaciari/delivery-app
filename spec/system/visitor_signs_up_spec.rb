require 'rails_helper'

describe 'Visitante cria uma conta' do
  it 'com sucesso' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

    visit root_path
    click_on 'Entrar (usuário)'
    click_on 'Inscrever-se'
    fill_in 'E-mail', with: 'usuario@express.com.br'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Inscrever-se'

    expect(current_path).to eq shipping_company_path(1)
    expect(page).to have_content 'Você realizou seu registro com sucesso.'
    expect(page).to have_content 'usuario@express.com.br'
    expect(page).to have_button 'Sair'
  end

  it 'com e-mail inválido' do
    ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                            email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

    visit root_path
    click_on 'Entrar (usuário)'
    click_on 'Inscrever-se'
    fill_in 'E-mail', with: 'usuario@email.com'
    click_on 'Inscrever-se'

    expect(current_path).to eq user_registration_path
    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).to have_content 'E-mail não possui um domínio registrado'
    expect(page).not_to have_button 'Sair'
  end

  it 'como administrador' do
    visit root_path
    click_on 'Entrar (administrador)'

    expect(page).not_to have_link 'Sign up'
  end
end
