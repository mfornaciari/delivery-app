# frozen_string_literal: true

class VolumeRangesController < ApplicationController
  before_action :authenticate_user_or_admin
  before_action :set_shipping_company, only: %i[new create]
  before_action :set_volume_range, only: %i[edit update]

  def new
    @volume_range = VolumeRange.new
    @volume_range.weight_ranges.build
    @form_model_attributes = [:shipping_company, @volume_range]
  end

  def create
    @volume_range = VolumeRange.new(volume_range_params)
    @volume_range.shipping_company = @shipping_company
    return redirect_to @shipping_company, notice: t('volume_range_creation_succeeded') if @volume_range.save

    @form_model_attributes = [:shipping_company, @volume_range]
    flash.now[:notice] = t('volume_range_creation_failed')
    render 'new'
  end

  def edit
    @form_model_attributes = @volume_range
  end

  def update
    if @volume_range.update(volume_range_params)
      return redirect_to @volume_range.shipping_company, notice: t('range_update_succeeded')
    end

    @form_model_attributes = @volume_range
    flash.now[:notice] = t('range_update_failed')
    render 'edit'
  end

  private

  def set_volume_range
    @volume_range = VolumeRange.find(params[:id])
  end

  def volume_range_params
    params.require(:volume_range).permit(:min_volume, :max_volume,
                                         weight_ranges_attributes: %i[id min_weight max_weight value])
  end
end
