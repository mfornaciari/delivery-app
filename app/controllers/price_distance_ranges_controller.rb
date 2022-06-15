class PriceDistanceRangesController < ApplicationController
  before_action :authenticate_user_or_admin
  before_action :set_shipping_company

  def new
    @price_distance_range = PriceDistanceRange.new
  end

  def create
    @price_distance_range = PriceDistanceRange.new(price_distance_range_params)
    @price_distance_range.shipping_company = @shipping_company
    if @price_distance_range.save
      redirect_to @shipping_company, notice: t('price_distance_range_creation_succeeded_message')
    else
      flash.now[:notice] = t('price_distance_range_creation_failed_message')
      render 'new'
    end
  end

  private

  def price_distance_range_params
    params.require(:price_distance_range).permit(%i[min_distance max_distance value])
  end
end
