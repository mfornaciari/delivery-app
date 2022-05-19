require 'rails_helper'

describe 'Visitante cadastra transportadora' do
  it 'com sucesso' do
    visit root_path
    click_on 'Transportadoras'
    click_on 'Cadastrar transportadora'
    within('form') do
      fill_in 'Nome fantasia', with: 'Express'
      fill_in 'Razão social', with: 'Express Transportes Ltda.'
      fill_in 'Domínio de e-mail', with: 'express.com.br'
      fill_in 'CNPJ', with: '28891540000121'
      fill_in 'Endereço', with: 'Avenida A, 10'
      fill_in 'Cidade', with: 'Rio de Janeiro'
      select 'RJ', from: 'Estado'
      click_on 'Criar Transportadora'
    end

    expect(current_path).to eq shipping_company_path(1)
    within('div#flash_messages') do
      expect(page).to have_content 'Transportadora cadastrada com sucesso.'
    end
    within('div#page_title') do
      expect(page).to have_content 'Express'
    end
    within('section#company_details') do
      expect(page).to have_content 'Nome fantasia: Express'
      expect(page).to have_content 'Razão social: Express Transportes Ltda.'
      expect(page).to have_content 'CNPJ: 28.891.540/0001-21'
      expect(page).to have_content 'Domínio de e-mail: express.com.br'
      expect(page).to have_content 'Endereço: Avenida A, 10 - Rio de Janeiro/RJ'
    end
  end

  it 'com dados incompletos ou inválidos' do
    visit root_path
    click_on 'Transportadoras'
    click_on 'Cadastrar transportadora'
    fill_in 'Nome fantasia', with: 'Express'
    click_on 'Criar Transportadora'

    expect(current_path).to eq shipping_companies_path
    within('div#flash_messages') do
      expect(page).to have_content 'Transportadora não cadastrada.'
    end
    within('form') do
      expect(page).to have_field 'Nome fantasia', with: 'Express'
      within('div#corporate_name') do
        expect(page).to have_content 'Razão social não pode ficar em branco'
      end
      within('div#registration_number') do
        expect(page).to have_content 'CNPJ não é válido'
      end
      within('div#email_domain') do
        expect(page).to have_content 'Domínio de e-mail não é válido'
      end
      within('div#address') do
        expect(page).to have_content 'Endereço não pode ficar em branco'
      end
      within('div#city') do
        expect(page).to have_content 'Cidade não pode ficar em branco'
      end
      within('div#state') do
        expect(page).to have_content 'Estado não pode ficar em branco'
      end
    end
  end
end
