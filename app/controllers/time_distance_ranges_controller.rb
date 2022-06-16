# frozen_string_literal: true

class TimeDistanceRangesController < ApplicationController
  before_action :authenticate_user_or_admin
  before_action :set_shipping_company

  def new
    @time_distance_range = TimeDistanceRange.new
  end

  def create
    @time_distance_range = TimeDistanceRange.new(time_distance_range_params)
    @time_distance_range.shipping_company = @shipping_company
    return redirect_to @shipping_company, notice: t('range_creation_succeeded') if @time_distance_range.save

    flash.now[:notice] = t('range_creation_failed')
    render 'new'
  end

  private

  def time_distance_range_params
    params.require(:time_distance_range).permit(%i[min_distance max_distance delivery_time])
  end
end
