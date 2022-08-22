# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  subject(:vehicle) { build :vehicle }

  it { is_expected.to belong_to(:shipping_company) }

  it { is_expected.to validate_presence_of(:model).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:brand).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:license_plate).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:production_year).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:maximum_load).with_message('não pode ficar em branco') }

  it { is_expected.to validate_uniqueness_of(:license_plate).with_message('já está em uso') }

  it { is_expected.to validate_numericality_of(:maximum_load).is_greater_than(0) }

  it 'license plate format validation' do
    expect(vehicle).not_to allow_values('ABCD123', 'ABC12345', 'ABCD1234')
      .for(:license_plate).with_message('não é válido')
    expect(vehicle).to allow_values('ABC1D23', 'ABC1234')
      .for(:license_plate)
  end

  it 'production year format validation' do
    expect(vehicle).not_to allow_values(1907, 1.year.from_now.year)
      .for(:production_year).with_message('deve estar entre 1908 e o ano atual')
    expect(vehicle).to allow_value(2022)
      .for(:production_year)
  end
end
