# frozen_string_literal: true

require 'rails_helper'

describe 'Visitante acessa a página inicial' do
  it 'e vê os links de autenticação' do
    visit root_path

    expect(page).to have_content 'SISTEMA DE GERENCIAMENTO DE ENTREGAS'
    expect(page).to have_link 'Entrar (usuário)'
    expect(page).to have_link 'Entrar (administrador)'
  end

  it 'e vê o menu de navegação' do
    create :express, brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                     email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                     address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ'

    visit root_path

    within('nav') do
      expect(page).to have_link 'Início'
      expect(page).not_to have_link 'Transportadoras'
      expect(page).not_to have_link 'Express'
      expect(page).not_to have_button 'Sair'
    end
  end

  it 'e vê a busca de pedidos' do
    visit root_path

    expect(page).to have_content 'Consultar status de entrega'
    expect(page).to have_field 'Código do pedido'
    expect(page).to have_button 'Consultar'
  end
end
