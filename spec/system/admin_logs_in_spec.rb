require 'rails_helper'

describe 'Administrador se autentica' do
  it 'com sucesso' do
    admin = Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')

    visit root_path
    login_admin(admin)

    expect(current_path).to eq shipping_companies_path
    expect(page).to have_content 'Login efetuado com sucesso'
    expect(page).to have_content 'admin@sistemadefrete.com.br'
    expect(page).to have_button 'Sair'
    expect(page).to have_link 'Transportadoras'
  end

  it 'e faz logout' do
    admin = Admin.create!(email: 'admin@sistemadefrete.com.br', password: 'password')

    visit root_path
    login_admin(admin)
    click_on 'Sair'

    expect(current_path).to eq root_path
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
  end
end
