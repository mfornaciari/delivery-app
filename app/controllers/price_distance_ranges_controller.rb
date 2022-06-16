class PriceDistanceRangesController < ApplicationController
  before_action :authenticate_user_or_admin
  before_action :set_shipping_company

  def new
    @price_distance_range = PriceDistanceRange.new
  end

  def create
    @price_distance_range = PriceDistanceRange.new(price_distance_range_params)
    @price_distance_range.shipping_company = @shipping_company
    return redirect_to @shipping_company, notice: t('range_creation_succeeded') if @price_distance_range.save

    flash.now[:notice] = t('range_creation_failed')
    render 'new'
  end

  private

  def price_distance_range_params
    params.require(:price_distance_range).permit(%i[min_distance max_distance value])
  end
end
