# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário vê tabela de prazos da transportadora' do
  let!(:express) { create :express }
  let(:user) { create :user }

  before { login_as user, scope: :user }

  it 'e não há intervalos de distância cadastrados' do
    visit shipping_company_path(express)

    expect(page).to have_content 'Tabela de prazos'
    within('section#delivery_times') do
      expect(page).to have_link 'Cadastrar intervalo de distância'
      expect(page).to have_content 'Não existem intervalos de distância cadastrados.'
    end
  end

  it 'e vê intervalos de distância' do
    create :time_distance_range, shipping_company: express,
                                 min_distance: 0,
                                 max_distance: 100,
                                 delivery_time: 2
    create :time_distance_range, shipping_company: express,
                                 min_distance: 101,
                                 max_distance: 200,
                                 delivery_time: 3

    visit shipping_company_path(express)

    within('section#delivery_times') do
      expect(page).not_to have_content 'Não existem intervalos de distância cadastrados.'
      within_table('delivery_times_table') do
        within('#table_header') do
          expect(page).to have_content 'Distância'
          expect(page).to have_content 'Prazo'
        end
        within('#0_100') do
          expect(page).to have_content '0-100 km'
          expect(page).to have_content '2 dias'
        end
        within('#101_200') do
          expect(page).to have_content '101-200 km'
          expect(page).to have_content '3 dias'
        end
      end
    end
  end
end
