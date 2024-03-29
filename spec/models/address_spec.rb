# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:valid_states) do
    {
      AC: 0,
      AL: 5,
      AP: 10,
      AM: 15,
      BA: 20,
      CE: 25,
      DF: 30,
      ES: 35,
      GO: 40,
      MA: 45,
      MT: 50,
      MS: 55,
      MG: 60,
      PA: 65,
      PB: 70,
      PR: 75,
      PE: 80,
      PI: 85,
      RJ: 90,
      RN: 95,
      RS: 100,
      RO: 105,
      RR: 110,
      SC: 115,
      SP: 120,
      SE: 125,
      TO: 130
    }
  end

  it { is_expected.to define_enum_for(:state).with_values(valid_states) }
  it { is_expected.to define_enum_for(:kind).with_values({ company: 0, pickup: 5, delivery: 10 }) }

  it { is_expected.to belong_to(:addressable) }

  it { is_expected.to validate_presence_of(:line1).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:city).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:state).with_message('não pode ficar em branco') }

  describe '#full_address' do
    subject do
      address = build :address, line1: 'Avenida A, 10', city: 'Natal', state: :RN
      address.full_address
    end

    it { is_expected.to eq('Avenida A, 10 - Natal/RN') }
  end
end
