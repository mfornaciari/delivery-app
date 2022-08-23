# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build :user }

  let!(:express) { create :express, email_domain: 'express.com.br' }

  it 'must not allow e-mails with unregistered domains' do
    create :a_jato, email_domain: 'ajato.com'

    expect(user).not_to allow_value('usuario@gmail.com')
      .for(:email).with_message('não possui um domínio registrado')
    expect(user).to allow_values('usuario@express.com.br', 'usuario@ajato.com')
      .for(:email)
  end

  describe '#set_shipping_company' do
    subject(:user_company) { (create :user, email: 'usuario@express.com.br').shipping_company }

    it { is_expected.to eq express }
  end
end
