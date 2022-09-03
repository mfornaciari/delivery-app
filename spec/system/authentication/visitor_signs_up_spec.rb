# frozen_string_literal: true

require 'rails_helper'

describe 'Visitante cria uma conta' do
  let!(:express) { create :express, email_domain: 'express.com.br' }

  it 'com sucesso' do
    visit new_user_session_path
    click_on 'Inscrever-se'
    fill_in 'E-mail', with: 'usuario@express.com.br'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Inscrever-se'

    expect(page).to have_current_path shipping_company_path(express)
    expect(page).to have_content 'Você realizou seu registro com sucesso.'
    expect(page).to have_content 'usuario@express.com.br'
    expect(page).to have_button 'Sair'
  end

  it 'com e-mail inválido' do
    visit new_user_session_path
    click_on 'Inscrever-se'
    fill_in 'E-mail', with: 'usuario@email.com'
    click_on 'Inscrever-se'

    expect(page).to have_current_path user_registration_path
    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).to have_content 'E-mail não possui um domínio registrado'
    expect(page).not_to have_button 'Sair'
  end

  it 'como administrador' do
    visit new_admin_session_path

    expect(page).not_to have_link 'Sign up'
  end
end
