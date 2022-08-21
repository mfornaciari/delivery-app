# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário acessa a tela de detalhes da sua transportadora' do
  it 'sem se autenticar' do
    express = create :express

    visit shipping_company_path(express)

    expect(page).to have_current_path new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'e vê detalhes completos' do
    express = create :express, :without_address, brand_name: 'Express',
                                                 corporate_name: 'Express Transportes Ltda.',
                                                 registration_number: 28_891_540_000_121,
                                                 email_domain: 'express.com.br'
    create :address, addressable: express, line1: 'Avenida A, 10', city: 'Natal', state: :RN
    user = create :user, email: 'usuario@express.com.br'

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
      expect(page).to have_content 'Endereço: Avenida A, 10 - Natal/RN'
    end
  end

  it 'e volta para a tela inicial' do
    express = create :express
    user = create :user

    login_as user, scope: :user
    visit shipping_company_path(express)
    click_on 'Voltar'

    expect(page).to have_current_path root_path
  end
end
