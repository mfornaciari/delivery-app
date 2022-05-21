class DistanceRangesController < ApplicationController
  before_action :set_shipping_company

  def new
    @distance_range = DistanceRange.new
  end

  def create
    @distance_range = DistanceRange.new(distance_range_params)
    @distance_range.shipping_company = @shipping_company
    if @distance_range.save
      redirect_to @shipping_company, notice: 'Intervalo cadastrado com sucesso.'
    else
      flash.now[:notice] = 'Intervalo não cadastrado.'
      render 'new'
    end
  end

  private

  def set_shipping_company
    @shipping_company = ShippingCompany.find(params[:shipping_company_id])
  end

  def distance_range_params
    params.require(:distance_range).permit(:min_distance, :max_distance, :value)
  end
end
