# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário registra um novo intervalo de peso' do
  it 'sem se autenticar' do
    express = create :express
    vrange = create :volume_range, shipping_company: express

    visit new_volume_range_weight_range_path(vrange)

    expect(page).to have_current_path new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    express = create :express
    user = create :user
    vrange = create :volume_range, shipping_company: express

    login_as user, scope: :user
    visit edit_volume_range_path(vrange)
    click_on 'Cadastrar intervalo de peso'
    fill_in 'Peso mínimo', with: '21'
    fill_in 'Peso máximo', with: '40'
    fill_in 'Valor', with: '75'
    click_on 'Criar Intervalo de peso'

    expect(page).to have_current_path edit_volume_range_path(vrange)
    expect(page).to have_content 'Intervalo cadastrado com sucesso.'
    expect(page).to have_field 'Peso mínimo', with: '21'
    expect(page).to have_field 'Peso máximo', with: '40'
    expect(page).to have_field 'Valor', with: '75'
  end

  it 'com dados incompletos' do
    express = create :express
    user = create :user
    vrange = create :volume_range, shipping_company: express

    login_as user, scope: :user
    visit new_volume_range_weight_range_path(vrange)
    fill_in 'Peso mínimo', with: '21'
    click_on 'Criar Intervalo de peso'

    expect(page).to have_current_path volume_range_weight_ranges_path(vrange)
    expect(page).to have_content 'Intervalo não cadastrado.'
    expect(page).to have_field 'Peso mínimo', with: '21'
    expect(page).to have_content 'Peso máximo não pode ficar em branco'
    expect(page).to have_content 'Valor não pode ficar em branco'
  end

  it 'com dados inválidos' do
    express = create :express
    user = create :user
    vrange = create :volume_range, shipping_company: express
    create :weight_range, volume_range: vrange, min_weight: 0, max_weight: 20, value: 50

    login_as user, scope: :user
    visit new_volume_range_weight_range_path(vrange)
    fill_in 'Peso mínimo', with: '0'
    fill_in 'Peso máximo', with: '0'
    click_on 'Criar Intervalo de peso'

    expect(page).to have_current_path volume_range_weight_ranges_path(vrange)
    expect(page).to have_content 'Peso mínimo não pode estar contido em intervalos já registrados'
    expect(page).to have_content 'Peso máximo deve ser maior que 0'
  end

  it 'com peso mínimo >= peso máximo' do
    express = create :express
    user = create :user
    vrange = create :volume_range, shipping_company: express

    login_as user, scope: :user
    visit new_volume_range_weight_range_path(vrange)
    fill_in 'Peso mínimo', with: '30'
    fill_in 'Peso máximo', with: '21'
    click_on 'Criar Intervalo de peso'

    expect(page).to have_current_path volume_range_weight_ranges_path(vrange)
    expect(page).to have_content 'Peso mínimo deve ser menor que o peso máximo'
  end
end
