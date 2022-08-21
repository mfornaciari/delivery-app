# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShippingCompany, type: :model do
  context 'Presença:' do
    it { is_expected.to validate_presence_of(:brand_name) }
    it { is_expected.to validate_presence_of(:corporate_name) }
    it { is_expected.to validate_presence_of(:email_domain) }
    it { is_expected.to validate_presence_of(:registration_number) }
  end

  context 'Associação:' do
    it { is_expected.to have_one(:address) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:vehicles) }
    it { is_expected.to have_many(:volume_ranges) }
    it { is_expected.to have_many(:weight_ranges).through(:volume_ranges) }
    it { is_expected.to have_many(:price_distance_ranges) }
    it { is_expected.to have_many(:time_distance_ranges) }
    it { is_expected.to have_many(:orders) }
  end

  context 'Formato:' do
    it 'Falso quando domínio do e-mail está vazio/em formato incorreto' do
      empty_company = described_class.new(email_domain: '')
      first_invalid_company = described_class.new(email_domain: 'express')
      second_invalid_company = described_class.new(email_domain: '-express.com.br')
      third_invalid_company = described_class.new(email_domain: 'express.com.br-')
      first_valid_company = described_class.new(email_domain: 'express.com')
      second_valid_company = described_class.new(email_domain: 'express.com.br')

      [empty_company, first_invalid_company, second_invalid_company, third_invalid_company,
       first_valid_company, second_valid_company].each(&:valid?)

      expect(empty_company.errors[:email_domain]).to include 'não é válido'
      expect(first_invalid_company.errors[:email_domain]).to include 'não é válido'
      expect(second_invalid_company.errors[:email_domain]).to include 'não é válido'
      expect(third_invalid_company.errors[:email_domain]).to include 'não é válido'
      expect(first_valid_company.errors.include?(:email_domain)).to be false
      expect(second_valid_company.errors.include?(:email_domain)).to be false
    end

    it 'Falso quando CNPJ está vazio/em formato incorreto' do
      empty_company = described_class.new(registration_number: '')
      first_invalid_company = described_class.new(registration_number: 8_891_540_000_121)
      second_invalid_company = described_class.new(registration_number: 128_891_540_000_121)
      valid_company = described_class.new(registration_number: 28_891_540_000_121)

      [empty_company, first_invalid_company, second_invalid_company, valid_company].each(&:valid?)

      expect(empty_company.errors[:registration_number]).to include 'não é válido'
      expect(first_invalid_company.errors[:registration_number]).to include 'não é válido'
      expect(second_invalid_company.errors[:registration_number]).to include 'não é válido'
      expect(valid_company.errors.include?(:registration_number)).to be false
    end
  end

  context 'Singularidade:' do
    it 'Falso quando CNPJ é repetido' do
      create :express, registration_number: 28_891_540_000_121
      company = described_class.new(registration_number: 28_891_540_000_121)

      company.valid?

      expect(company.errors[:registration_number]).to include 'já está em uso'
    end
  end
end
