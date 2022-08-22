# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin, type: :model do
  it { is_expected.not_to allow_value('admin@gmail.com').for(:email).with_message('não é válido') }
  it { is_expected.to allow_value('admin@sistemadefrete.com.br').for(:email) }
end
