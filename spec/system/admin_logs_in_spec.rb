require 'rails_helper'

describe 'Administrador se autentica' do
  it 'com sucesso' do
    Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')

    visit root_path
    click_on 'Entrar (administrador)'
    fill_in 'E-mail', with: 'admin@sistemadefrete.com.br'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'

    expect(current_path).to eq shipping_companies_path
    expect(page).to have_content 'Login efetuado com sucesso'
    expect(page).to have_content 'admin@sistemadefrete.com.br'
    expect(page).to have_button 'Sair'
    expect(page).to have_link 'Transportadoras'
  end

  it 'e faz logout' do
    admin = Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')

    login_as admin, scope: :admin
    visit root_path
    click_on 'Sair'

    expect(current_path).to eq root_path
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
  end
end