# frozen_string_literal: true

require 'rails_helper'

describe 'Visitante acessa a página inicial' do
  subject { page }

  before { visit root_path }

  it { is_expected.to have_content 'SISTEMA DE GERENCIAMENTO DE ENTREGAS' }
  it { is_expected.to have_link 'Entrar (usuário)' }
  it { is_expected.to have_link 'Entrar (administrador)' }
  it { is_expected.to have_content 'Consultar status de entrega' }
  it { is_expected.to have_field 'Código do pedido' }
  it { is_expected.to have_button 'Consultar' }

  it 'e vê o menu de navegação' do
    within('nav') do
      expect(page).to have_link 'Início'
      expect(page).not_to have_link 'Transportadoras'
      expect(page).not_to have_link 'Express'
      expect(page).not_to have_button 'Sair'
    end
  end
end
