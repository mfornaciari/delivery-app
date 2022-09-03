# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Price, type: :model do
  it { is_expected.to validate_presence_of(:min_volume).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:max_volume).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:min_weight).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:max_weight).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:value).with_message('não pode ficar em branco') }

  it { is_expected.to validate_numericality_of(:min_volume).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:max_volume).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:min_weight).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:max_weight).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:value).is_greater_than_or_equal_to(0) }
end
