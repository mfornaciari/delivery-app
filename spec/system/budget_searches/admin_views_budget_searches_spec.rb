# frozen_string_literal: true

require 'rails_helper'

describe 'Administrador vê as buscas de preço realizadas' do
  it 'na página inicial' do
    admin = create :admin, email: 'admin@sistemadefrete.com.br'
    other_admin = create :admin, email: 'other@sistemadefrete.com.br'
    create :budget_search, admin: admin
    create :budget_search, admin: other_admin

    login_as admin, scope: :admin
    visit root_path

    expect(page).not_to have_content 'Não há buscas de orçamento registradas.'
    expect(page).to have_content 'Buscas realizadas:'
    within_table('budget_searches') do
      within('#table_header') do
        expect(page).to have_content 'No. da busca'
        expect(page).to have_content 'Data'
        expect(page).to have_content 'Administrador'
      end
      within('#1') do
        expect(page).to have_content '1'
        expect(page).to have_content I18n.l(Date.current)
        expect(page).to have_content 'admin@sistemadefrete.com.br'
      end
      within('#2') do
        expect(page).to have_content '2'
        expect(page).to have_content I18n.l(Date.current)
        expect(page).to have_content 'other@sistemadefrete.com.br'
      end
    end
  end

  it 'e não há nenhuma' do
    admin = create :admin

    login_as admin, scope: :admin
    visit root_path

    expect(page).to have_content 'Não há buscas de orçamento registradas.'
  end

  it 'e acessa os detalhes de uma' do
    admin = create :admin
    create :budget_search, admin: admin

    login_as admin, scope: :admin
    visit root_path
    click_on '1'

    expect(page).to have_current_path budget_search_path 1
  end
end
