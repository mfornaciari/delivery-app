class BudgetSearchesController < ApplicationController
  before_action :authenticate_admin!

  def new
    @budget_search = BudgetSearch.new
  end

  def create
    @budget_search = BudgetSearch.new(budget_search_params)
    @budget_search.admin = current_admin
    if @budget_search.save
      redirect_to @budget_search, notice: 'Resultado da sua busca:'
    else
      flash.now[:notice] = 'Sua busca não pôde ser realizada.'
      render 'new'
    end
  end

  def show
    @budget_search = BudgetSearch.find params[:id]
    @prices_and_times = prices_and_times(@budget_search)
  end

  private

  def budget_search_params
    params.require(:budget_search).permit(:height, :width, :depth, :weight, :distance)
  end

  def prices_and_times(search)
    price_time_hash = {}
    valid_weight_ranges(search).each do |wrange|
      company = wrange.volume_range.shipping_company
      delivery_time = company_delivery_time(company, search)
      next unless delivery_time

      min_price = company_min_price(company, search)
      price = wrange.value * search.distance
      price = min_price && price < min_price ? min_price : price
      price_time_hash[company] = [price, delivery_time]
    end
    price_time_hash
  end

  def valid_weight_ranges(search)
    WeightRange.joins(:volume_range).where(
      'min_weight <= :weight AND max_weight >= :weight AND
      volume_ranges.min_volume <= :volume AND volume_ranges.max_volume >= :volume',
      weight: search.weight, volume: search.volume
    )
  end

  def company_delivery_time(company, search)
    company.time_distance_ranges.find_by('min_distance <= :distance AND max_distance >= :distance',
                                         distance: search.distance)&.delivery_time
  end

  def company_min_price(company, search)
    company.price_distance_ranges.find_by('min_distance <= :distance AND max_distance >= :distance',
                                          distance: search.distance)&.value
  end
end
