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
    @search = BudgetSearch.find params[:id]
    @distance = @search.distance
    @volume = @search.volume
    @weight = @search.weight
    @company_info = {}
    ShippingCompany.all.each do |company|
      delivery_time = company.delivery_time(distance: @distance)
      next if delivery_time.nil?

      value = company.value(volume: @volume, weight: @weight, distance: @distance)
      value.nil? ? next : value /= 100

      @company_info[company] = { value:, delivery_time: }
    end
  end

  private

  def budget_search_params
    params.require(:budget_search).permit(:height, :width, :depth, :weight, :distance)
  end
end
