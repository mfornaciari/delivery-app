# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário de transportadora se autentica' do
  let!(:express) { create :express }
  let!(:user) { create :user, email: 'usuario@express.com.br', password: 'password' }

  it 'com sucesso' do
    visit root_path
    click_on 'Entrar (usuário)'
    fill_in 'E-mail', with: 'usuario@express.com.br'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'

    expect(page).to have_current_path shipping_company_path(express)
    expect(page).to have_content 'Login efetuado com sucesso'
    expect(page).to have_content 'usuario@express.com.br'
    expect(page).to have_button 'Sair'
    expect(page).to have_link 'Express'
    expect(page).not_to have_link 'Transportadoras'
    expect(page).not_to have_link 'Entrar (administrador)'
    expect(page).not_to have_link 'Entrar (usuário)'
  end

  it 'e faz logout' do
    login_as user, scope: :user
    visit root_path
    click_on 'Sair'

    expect(page).to have_current_path root_path
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
  end
end
