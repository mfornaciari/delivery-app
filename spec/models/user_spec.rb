require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'Valor:' do
      it 'Falso quando domínio de e-mail não está registrado' do
        ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        ShippingCompany.create!(brand_name: 'A Jato', corporate_name: 'A Jato S.A.',
                                email_domain: 'ajato.com', registration_number: 19_824_380_000_107,
                                address: 'Avenida B, 23', city: 'Natal', state: 'RN')
        invalid_user = User.new(email: 'usuario@email.com')
        first_valid_user = User.new(email: 'usuario@express.com.br')
        second_valid_user = User.new(email: 'usuario@ajato.com')

        [invalid_user, first_valid_user, second_valid_user].each(&:valid?)

        expect(invalid_user.errors[:email]).to include 'não possui um domínio registrado'
        expect(first_valid_user.errors.include?(:email)).to eq false
        expect(second_valid_user.errors.include?(:email)).to eq false
      end
    end
  end

  describe '#set_shipping_company' do
    it 'Deve atribuir transportadora com base no domínio de e-mail' do
      ShippingCompany.create!(brand_name: 'A Jato', corporate_name: 'A Jato S.A.',
                              email_domain: 'ajato.com', registration_number: 19_824_380_000_107,
                              address: 'Avenida B, 23', city: 'Natal', state: 'RN')
      express = ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                        email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                        address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
      user = User.new(email: 'usuario@express.com.br', password: 'password')

      user.valid?

      expect(user.shipping_company).to eq express
    end
  end
end
