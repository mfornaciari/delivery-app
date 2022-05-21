class VolumeRangesController < ApplicationController
  before_action :set_shipping_company, only: %i[new create]
  before_action :set_volume_range, only: %i[edit update]

  def new
    @volume_range = VolumeRange.new
    @volume_range.weight_ranges.new
    @weight_ranges = @volume_range.weight_ranges
    @form_model_attributes = [:shipping_company, @volume_range]
  end

  def create
    @volume_range = VolumeRange.new(volume_range_params)
    @volume_range.shipping_company = @shipping_company
    if @volume_range.save
      redirect_to @shipping_company, notice: 'Intervalo cadastrado com sucesso.'
    else
      @weight_ranges = @volume_range.weight_ranges
      @form_model_attributes = [:shipping_company, @volume_range]
      flash.now[:notice] = 'Intervalo não cadastrado.'
      render 'new'
    end
  end

  def edit
    @form_model_attributes = @volume_range
    @weight_ranges = @volume_range.weight_ranges
  end

  def update
    if @volume_range.update(volume_range_params)
      redirect_to @volume_range.shipping_company, notice: 'Intervalo atualizado com sucesso.'
    else
      @weight_ranges = @volume_range.weight_ranges
      @form_model_attributes = @volume_range
      flash.now[:notice] = 'Intervalo não atualizado.'
      render 'edit'
    end
  end

  private

  def set_volume_range
    @volume_range = VolumeRange.find(params[:id])
  end

  def set_shipping_company
    @shipping_company = ShippingCompany.find(params[:shipping_company_id])
  end

  def volume_range_params
    params.require(:volume_range).permit(:min_volume, :max_volume,
                                         weight_ranges_attributes: %i[id min_weight max_weight value])
  end
end
