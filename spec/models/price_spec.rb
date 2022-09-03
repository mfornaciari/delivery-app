# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Price, type: :model do
  it { is_expected.to validate_presence_of(:min_volume).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:max_volume).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:min_weight).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:max_weight).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:value).with_message('não pode ficar em branco') }
end
