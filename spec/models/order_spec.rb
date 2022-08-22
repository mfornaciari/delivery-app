# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to have_one(:pickup_address) }
  it { is_expected.to have_one(:delivery_address) }

  it { is_expected.to validate_presence_of(:recipient_name).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:product_code).with_message('não pode ficar em branco') }

  describe '#generate_code' do
    subject(:order) { create :order, :for_express }

    it 'creates 15 character alphanumeric code' do
      expect(order.code).to match(/\A[[:alnum:]]{15}\z/)
    end

    it 'creates unique code' do
      new_order = create :order, :for_a_jato

      expect(order.code).not_to eq new_order.code
    end

    it 'creates code that does not change on update' do
      original_code = order.code

      order.accepted!

      expect(order.code).to eq original_code
    end
  end
end
