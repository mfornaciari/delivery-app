# frozen_string_literal: true

require 'rails_helper'

describe 'Administrador acessa o índice de transportadoras,' do
  it 'sem se autenticar' do
    visit shipping_companies_path

    expect(page).to have_current_path new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  context 'autenticado,' do
    let(:admin) { create :admin }

    before { login_as admin, scope: :admin }

    it 'e vê as transportadoras cadastradas' do
      express = create :express, :without_address, brand_name: 'Express',
                                                   corporate_name: 'Express Transportes Ltda.',
                                                   email_domain: 'express.com.br',
                                                   registration_number: 28_891_540_000_121
      create :address, addressable: express, line1: 'Avenida A, 10', city: 'Rio de Janeiro', state: :RJ
      a_jato = create :a_jato, :without_address, brand_name: 'A Jato',
                                                 corporate_name: 'A Jato S.A.',
                                                 email_domain: 'ajato.com',
                                                 registration_number: 19_824_380_000_107
      create :address, addressable: a_jato, line1: 'Avenida B, 23', city: 'Natal', state: :RN

      visit root_path
      click_on 'Transportadoras'

      within('#table_header') do
        expect(page).to have_content 'Nome fantasia'
        expect(page).to have_content 'Razão social'
        expect(page).to have_content 'Domínio de e-mail'
        expect(page).to have_content 'CNPJ'
        expect(page).to have_content 'Endereço'
      end
      within('#Express') do
        expect(page).to have_content 'Express'
        expect(page).to have_content 'Express Transportes Ltda.'
        expect(page).to have_content 'express.com.br'
        expect(page).to have_content '28.891.540/0001-21'
        expect(page).to have_content 'Avenida A, 10 - Rio de Janeiro/RJ'
      end
      within('#A_Jato') do
        expect(page).to have_content 'A Jato'
        expect(page).to have_content 'A Jato S.A.'
        expect(page).to have_content 'ajato.com'
        expect(page).to have_content '19.824.380/0001-07'
        expect(page).to have_content 'Avenida B, 23 - Natal/RN'
      end
    end

    it 'e não há transportadoras cadastradas' do
      visit shipping_companies_path

      expect(page).to have_content 'Não existem transportadoras cadastradas.'
      expect(page).not_to have_table 'shipping_companies'
    end
  end
end
