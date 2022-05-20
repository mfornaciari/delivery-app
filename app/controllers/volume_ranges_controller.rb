class VolumeRangesController < ApplicationController
  before_action :set_shipping_company

  def new
    @volume_range = VolumeRange.new
    @weight_range = @volume_range.weight_ranges.new
  end

  def create
    @volume_range = VolumeRange.new(volume_range_params)
    @volume_range.shipping_company = @shipping_company
    if @volume_range.save
      redirect_to @shipping_company, notice: 'Intervalo cadastrado com sucesso.'
    else
      @weight_range = @volume_range.weight_ranges.last
      flash.now[:notice] = 'Intervalo não cadastrado.'
      render 'new'
    end
  end

  private

  def set_shipping_company
    @shipping_company = ShippingCompany.find(params[:shipping_company_id])
  end

  def volume_range_params
    params.require(:volume_range).permit(:min_volume, :max_volume,
                                         weight_ranges_attributes: %i[id min_weight max_weight value])
  end
end
