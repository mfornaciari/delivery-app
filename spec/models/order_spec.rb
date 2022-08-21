# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to have_one(:pickup_address) }
  it { is_expected.to have_one(:delivery_address) }

  it { is_expected.to validate_presence_of(:recipient_name) }
  it { is_expected.to validate_presence_of(:product_code) }

  describe 'Gera um código aleatório' do
    it 'ao criar um novo pedido' do
      order = create :order

      order.save!

      expect(order.code).not_to be_empty
      expect(order.code.length).to eq 15
    end

    it 'e ele é único' do
      order1 = create :order
      order2 = create :order, shipping_company: order1.shipping_company

      order2.save!

      expect(order2.code).not_to eq order1.code
    end

    it 'e ele não muda após atualização' do
      order = create :order

      original_code = order.code
      order.accepted!

      expect(order.code).to eq original_code
    end
  end
end
