# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário acessa a tela de detalhes da sua transportadora' do
  it 'sem se autenticar' do
    create :express

    visit shipping_company_path(1)

    expect(page).to have_current_path new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'e vê detalhes completos' do
    create :express
    user = create :user

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
    create :express
    user = create :user

    login_as user, scope: :user
    visit shipping_company_path(1)
    click_on 'Voltar'

    expect(page).to have_current_path root_path
  end
end
