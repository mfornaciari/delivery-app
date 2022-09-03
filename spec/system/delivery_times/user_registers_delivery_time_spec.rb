# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário registra um novo intervalo de distância,' do
  let!(:express) { create :express }

  it 'sem se autenticar' do
    visit new_shipping_company_time_distance_range_path(express)

    expect(page).to have_current_path new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  context 'autenticado,' do
    let(:user) { create :user }

    before { login_as user, scope: :user }

    it 'com sucesso' do
      visit shipping_company_path(express)
      find('section#delivery_times').click_on 'Cadastrar intervalo de distância'
      fill_in 'Distância mínima', with: '0'
      fill_in 'Distância máxima', with: '100'
      fill_in 'Prazo', with: '2'
      click_on 'Criar Intervalo de distância'

      expect(page).to have_content 'Intervalo cadastrado com sucesso.'
      within_table('delivery_times_table') do
        expect(page).to have_content '0-100 km'
        expect(page).to have_content '2 dias'
      end
    end

    it 'com dados incompletos' do
      visit new_shipping_company_time_distance_range_path(express)
      fill_in 'Distância mínima', with: '0'
      click_on 'Criar Intervalo de distância'

      expect(page).to have_content 'Intervalo não cadastrado.'
      expect(page).to have_field 'Distância mínima', with: '0'
      expect(page).to have_content 'Distância máxima não pode ficar em branco'
      expect(page).to have_content 'Prazo não pode ficar em branco'
    end

    it 'com dados inválidos' do
      create :time_distance_range, shipping_company: express, min_distance: 0

      visit new_shipping_company_time_distance_range_path(express)
      fill_in 'Distância mínima', with: '0'
      fill_in 'Distância máxima', with: '0'
      click_on 'Criar Intervalo de distância'

      expect(page).to have_content 'Distância mínima não pode estar contida em intervalos já registrados'
      expect(page).to have_content 'Distância máxima deve ser maior que 0'
    end

    it 'com distância mínima >= distância máxima' do
      visit new_shipping_company_time_distance_range_path(express)
      fill_in 'Distância mínima', with: '10'
      fill_in 'Distância máxima', with: '5'
      click_on 'Criar Intervalo de distância'

      expect(page).to have_content 'Distância mínima deve ser menor que distância máxima'
    end
  end
end
