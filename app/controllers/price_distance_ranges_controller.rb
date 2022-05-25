class PriceDistanceRangesController < ApplicationController
  before_action :check_user_login
  before_action :set_shipping_company

  def new
    @price_distance_range = PriceDistanceRange.new
  end

  def create
    @price_distance_range = PriceDistanceRange.new(price_distance_range_params)
    @price_distance_range.shipping_company = @shipping_company
    if @price_distance_range.save
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

  def price_distance_range_params
    params.require(:price_distance_range).permit(:min_distance, :max_distance, :value)
  end

  def check_user_login
    authenticate_user! unless admin_signed_in?
  end
end
