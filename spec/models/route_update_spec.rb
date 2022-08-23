# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RouteUpdate, type: :model do
  subject(:route_update) { build :route_update }

  it { is_expected.to belong_to(:order) }

  it { is_expected.to validate_presence_of(:date_and_time).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:latitude).with_message('não pode ficar em branco') }
  it { is_expected.to validate_presence_of(:longitude).with_message('não pode ficar em branco') }

  it 'latitude value validation' do
    expect(route_update).to validate_numericality_of(:latitude)
      .is_greater_than_or_equal_to(-90).is_less_than_or_equal_to(90)
  end

  it 'longitude value validation' do
    expect(route_update).to validate_numericality_of(:longitude)
      .is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180)
  end

  it { is_expected.not_to allow_value(1.second.from_now).for(:date_and_time) }
  it { is_expected.to allow_value(1.second.ago).for(:date_and_time) }

  it 'must not allow date and time to predate last update' do
    create :route_update, order: route_update.order, date_and_time: 1.second.ago

    route_update.order.reload

    expect(route_update).not_to allow_value(2.seconds.ago)
      .for(:date_and_time).with_message('não podem ser anteriores à última atualização')
  end
end
