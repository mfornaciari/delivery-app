# frozen_string_literal: true

require 'rails_helper'

describe 'Administrador cadastra transportadora' do
  it 'sem se autenticar' do
    visit new_shipping_company_path

    expect(page).to have_current_path new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    admin = create :admin

    login_as admin, scope: :admin
    visit shipping_companies_path
    click_on 'Cadastrar transportadora'
    fill_in 'Nome fantasia', with: 'Express'
    fill_in 'Razão social', with: 'Express Transportes Ltda.'
    fill_in 'Domínio de e-mail', with: 'express.com.br'
    fill_in 'CNPJ', with: '28891540000121'
    fill_in 'Endereço', with: 'Avenida A, 10'
    fill_in 'Cidade', with: 'Rio de Janeiro'
    select 'RJ', from: 'Estado'
    click_on 'Criar Transportadora'

    expect(page).to have_current_path shipping_company_path(1)
    expect(page).to have_content 'Transportadora cadastrada com sucesso.'
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

  it 'com dados incompletos ou inválidos' do
    admin = create :admin

    login_as admin, scope: :admin
    visit new_shipping_company_path
    fill_in 'Nome fantasia', with: 'Express'
    click_on 'Criar Transportadora'

    expect(page).to have_current_path shipping_companies_path
    expect(page).to have_content 'Transportadora não cadastrada.'
    expect(page).to have_field 'Nome fantasia', with: 'Express'
    expect(page).to have_content 'Razão social não pode ficar em branco'
    expect(page).to have_content 'CNPJ não é válido'
    expect(page).to have_content 'Domínio de e-mail não é válido'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
  end
end
