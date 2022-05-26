class BudgetSearchesController < ApplicationController
  before_action :authenticate_admin!

  def new
    @budget_search = BudgetSearch.new
  end

  def create
    @budget_search = BudgetSearch.new(budget_search_params)
    @budget_search.admin = current_admin
    redirect_to @budget_search, notice: 'Resultado da sua busca:' if @budget_search.save!
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
    weight_ranges = WeightRange.where('min_weight <= :weight AND max_weight >= :weight', weight: search.weight)
    weight_ranges = weight_ranges.select do |wrange|
      search.volume.between?(wrange.volume_range.min_volume, wrange.volume_range.max_volume)
    end

    price_time_hash = {}
    weight_ranges.each do |wrange|
      company = wrange.volume_range.shipping_company
      min_price = company.price_distance_ranges.find_by('min_distance <= :distance AND max_distance >= :distance',
                                                        distance: search.distance).value
      price = wrange.value * search.distance
      price = price < min_price ? min_price : price
      delivery_time = company.time_distance_ranges.find_by('min_distance <= :distance AND max_distance >= :distance',
                                                           distance: search.distance).delivery_time
      price_time_hash[company] = [price, delivery_time]
    end
    price_time_hash
  end
end
