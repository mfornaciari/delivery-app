# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'Valor:' do
      it 'Falso quando domínio de e-mail não está registrado' do
        create :express, email_domain: 'express.com.br'
        create :a_jato, email_domain: 'ajato.com'
        invalid_user = described_class.new(email: 'usuario@email.com')
        first_valid_user = described_class.new(email: 'usuario@express.com.br')
        second_valid_user = described_class.new(email: 'usuario@ajato.com')

        [invalid_user, first_valid_user, second_valid_user].each(&:valid?)

        expect(invalid_user.errors[:email]).to include 'não possui um domínio registrado'
        expect(first_valid_user.errors.include?(:email)).to eq false
        expect(second_valid_user.errors.include?(:email)).to eq false
      end
    end
  end

  describe '#set_shipping_company' do
    it 'Deve atribuir transportadora com base no domínio de e-mail' do
      create :a_jato, email_domain: 'ajato.com'
      express = create :express, email_domain: 'express.com.br'
      user = create :user, email: 'usuario@express.com.br'

      user.valid?

      expect(user.shipping_company).to eq express
    end
  end
end
