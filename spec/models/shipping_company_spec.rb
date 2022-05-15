require 'rails_helper'

RSpec.describe ShippingCompany, type: :model do
  describe '#valid?' do
    context 'presença' do
      it 'falso quando nome fantasia está em branco' do
        company = ShippingCompany.new(brand_name: '', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

        company.valid?

        expect(company.errors.full_messages.length).to eq 1
        expect(company.errors.full_messages[0]).to eq 'Nome fantasia não pode ficar em branco'
      end

      it 'falso quando razão social está em branco' do
        company = ShippingCompany.new(brand_name: 'Express', corporate_name: '', email_domain: 'express.com.br',
                                      registration_number: 28_891_540_000_121, address: 'Avenida A, 10',
                                      city: 'Rio de Janeiro', state: 'RJ')

        company.valid?

        expect(company.errors.full_messages.length).to eq 1
        expect(company.errors.full_messages[0]).to eq 'Razão social não pode ficar em branco'
      end

      it 'falso quando endereço está em branco' do
        company = ShippingCompany.new(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: '', city: 'Rio de Janeiro', state: 'RJ')

        company.valid?

        expect(company.errors.full_messages.length).to eq 1
        expect(company.errors.full_messages[0]).to eq 'Endereço não pode ficar em branco'
      end

      it 'falso quando cidade está em branco' do
        company = ShippingCompany.new(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: '', state: 'RJ')

        company.valid?

        expect(company.errors.full_messages.length).to eq 1
        expect(company.errors.full_messages[0]).to eq 'Cidade não pode ficar em branco'
      end

      it 'falso quando estado está em branco' do
        company = ShippingCompany.new(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                      email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                      address: 'Avenida A, 10', city: 'Rio de Janeiro', state: '')

        company.valid?

        expect(company.errors.full_messages.length).to eq 1
        expect(company.errors.full_messages[0]).to eq 'Estado não pode ficar em branco'
      end
    end

    context 'formato' do
      it 'falso quando domínio do e-mail está vazio/em formato incorreto' do
        first_invalid = ShippingCompany.new(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                            email_domain: 'express', registration_number: 28_891_540_000_121,
                                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        second_invalid = ShippingCompany.new(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                             email_domain: '-express.com.br', registration_number: 28_891_540_000_121,
                                             address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        third_invalid = ShippingCompany.new(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                            email_domain: 'express.com.br-', registration_number: 28_891_540_000_121,
                                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        empty = ShippingCompany.new(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                    email_domain: '', registration_number: 28_891_540_000_121,
                                    address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        first_valid = ShippingCompany.new(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                          email_domain: 'express.com', registration_number: 28_891_540_000_121,
                                          address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        second_valid = ShippingCompany.new(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                           email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                           address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

        [first_invalid, second_invalid, third_invalid, empty].each(&:valid?)

        expect(first_invalid.errors.full_messages.length).to eq 1
        expect(first_invalid.errors.full_messages[0]).to eq 'Domínio de e-mail não é válido'
        expect(second_invalid.errors.full_messages.length).to eq 1
        expect(second_invalid.errors.full_messages[0]).to eq 'Domínio de e-mail não é válido'
        expect(third_invalid.errors.full_messages.length).to eq 1
        expect(third_invalid.errors.full_messages[0]).to eq 'Domínio de e-mail não é válido'
        expect(empty.errors.full_messages.length).to eq 1
        expect(empty.errors.full_messages[0]).to eq 'Domínio de e-mail não é válido'
        expect(first_valid).to be_valid
        expect(second_valid).to be_valid
      end

      it 'falso quando CNPJ está vazio/em formato incorreto' do
        first_invalid = ShippingCompany.new(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                            email_domain: 'express.com.br', registration_number: 8_891_540_000_121,
                                            address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        second_invalid = ShippingCompany.new(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                             email_domain: 'express.com.br', registration_number: 128_891_540_000_121,
                                             address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        empty = ShippingCompany.new(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                    email_domain: 'express.com.br', registration_number: '',
                                    address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        valid = ShippingCompany.new(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                    email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                    address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')

        [first_invalid, second_invalid, empty].each(&:valid?)

        expect(first_invalid.errors.full_messages.length).to eq 1
        expect(first_invalid.errors.full_messages[0]).to eq 'CNPJ não é válido'
        expect(second_invalid.errors.full_messages.length).to eq 1
        expect(second_invalid.errors.full_messages[0]).to eq 'CNPJ não é válido'
        expect(empty.errors.full_messages.length).to eq 1
        expect(empty.errors.full_messages[0]).to eq 'CNPJ não é válido'
        expect(valid).to be_valid
      end
    end

    context 'singularidade' do
      it 'falso quando CNPJ é repetido' do
        ShippingCompany.create!(brand_name: 'Express', corporate_name: 'Express Transportes Ltda.',
                                email_domain: 'express.com.br', registration_number: 28_891_540_000_121,
                                address: 'Avenida A, 10', city: 'Rio de Janeiro', state: 'RJ')
        company = ShippingCompany.new(brand_name: 'A Jato', corporate_name: 'A Jato S/A', email_domain: 'ajato.com',
                                      registration_number: 28_891_540_000_121, address: 'Avenida B, 23',
                                      city: 'Natal', state: 'RN')

        company.valid?

        expect(company.errors.full_messages.length).to eq 1
        expect(company.errors.full_messages[0]).to eq 'CNPJ já está em uso'
      end
    end
  end
end
