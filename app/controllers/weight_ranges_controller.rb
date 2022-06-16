# frozen_string_literal: true

class WeightRangesController < ApplicationController
  before_action :authenticate_user_or_admin
  before_action :set_volume_range, only: %i[new create]

  def new
    @weight_range = WeightRange.new
  end

  def create
    @weight_range = WeightRange.new(weight_range_params)
    @weight_range.volume_range = @volume_range
    if @weight_range.save
      return redirect_to edit_volume_range_path(@volume_range), notice: t('range_creation_succeeded')
    end

    flash.now[:notice] = t('range_creation_failed')
    render 'new'
  end

  private

  def set_volume_range
    @volume_range = VolumeRange.find(params[:volume_range_id])
  end

  def weight_range_params
    params.require(:weight_range).permit(%i[min_weight max_weight value])
  end
end
