# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BudgetSearch, type: :model do
  it { is_expected.to belong_to(:admin) }

  it { is_expected.to validate_presence_of(:height).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:width).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:depth).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:weight).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:distance).with_message('não pode ficar em branco') }

  it { is_expected.to validate_numericality_of(:height).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:width).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:depth).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:weight).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:distance).is_greater_than(0) }

  describe '#set_volume_in_cubic_meters' do
    subject(:volume) { (create :budget_search, height: 100, width: 100, depth: 100).volume }

    it { is_expected.to eq 1 }
  end
end
