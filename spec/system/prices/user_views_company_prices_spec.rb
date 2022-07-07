# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário vê tabela de preços da transportadora' do
  it 'e não há intervalos de volume cadastrados' do
    express = create :express
    user = create :user

    login_as user, scope: :user
    visit shipping_company_path(express)

    expect(page).to have_content 'Tabela de preços'
    expect(page).to have_link 'Cadastrar intervalo de volume'
    expect(page).to have_content 'Não existem intervalos de volume cadastrados.'
  end

  it 'e vê intervalos de volume cadastrados' do
    express = create :express
    user = create :user
    volume_range1 = create :volume_range, shipping_company: express, min_volume: 1, max_volume: 50
    create :weight_range, volume_range: volume_range1, min_weight: 1, max_weight: 20, value: 50
    create :weight_range, volume_range: volume_range1, min_weight: 21, max_weight: 40, value: 75
    volume_range2 = create :volume_range, shipping_company: express, min_volume: 51, max_volume: 100
    create :weight_range, volume_range: volume_range2, min_weight: 1, max_weight: 20, value: 75

    login_as user, scope: :user
    visit shipping_company_path(express)

    expect(page).not_to have_content 'Não existem intervalos de volume cadastrados.'
    within_table('prices_table') do
      within('#table_header') do
        expect(page).to have_content 'Volume'
        expect(page).to have_content 'Peso'
        expect(page).to have_content 'Valor por km'
      end
      within('#1_50_1') do
        expect(page).to have_content '1-50 m3'
        expect(page).to have_content '1-20 kg'
        expect(page).to have_content 'R$ 0,50'
      end
      within('#1_50_2') do
        expect(page).to have_content '21-40 kg'
        expect(page).to have_content 'R$ 0,75'
      end
      within('#51_100_1') do
        expect(page).to have_content '51-100 m3'
        expect(page).to have_content '1-20 kg'
        expect(page).to have_content 'R$ 0,75'
      end
    end
  end
end
