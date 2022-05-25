require 'rails_helper'

describe 'Visitante acessa a página inicial' do
  it 'e vê o título da aplicação' do
    visit root_path

    within('header') do
      expect(page).to have_content 'SISTEMA DE GERENCIAMENTO DE ENTREGAS'
    end
  end

  it 'e vê o menu de navegação' do
    visit root_path

    within('nav') do
      expect(page).to have_link 'Início'
    end
  end
end
