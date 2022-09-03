# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário vê tabela de preços mínimos da transportadora' do
  let!(:express) { create :express }
  let(:user) { create :user }

  before { login_as user, scope: :user }

  it 'e não há intervalos de distância cadastrados' do
    visit shipping_company_path(express)

    within('section#prices') do
      expect(page).to have_content 'Preços mínimos por distância'
      expect(page).to have_link 'Cadastrar intervalo de distância'
      expect(page).to have_content 'Não existem intervalos de distância cadastrados.'
    end
  end

  it 'e vê intervalos de distância' do
    create :price_distance_range, shipping_company: express, min_distance: 0, max_distance: 100, value: 5_000
    create :price_distance_range, shipping_company: express, min_distance: 101, max_distance: 200, value: 10_000

    visit shipping_company_path(express)

    within('section#prices') { expect(page).not_to have_content 'Não existem intervalos de distância cadastrados.' }
    within_table('min_prices_table') do
      within('#table_header') do
        expect(page).to have_content 'Distância'
        expect(page).to have_content 'Valor mínimo'
      end
      within('#0_100') do
        expect(page).to have_content '0-100 km'
        expect(page).to have_content 'R$ 50,00'
      end
      within('#101_200') do
        expect(page).to have_content '101-200 km'
        expect(page).to have_content 'R$ 100,00'
      end
    end
  end
end
