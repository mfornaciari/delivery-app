# frozen_string_literal: true

class BudgetSearchesController < ApplicationController
  before_action :authenticate_admin!

  def new
    @budget_search = BudgetSearch.new
  end

  def create
    @budget_search = BudgetSearch.new(budget_search_params)
    @budget_search.admin = current_admin
    return redirect_to @budget_search, notice: t('search_succeeded_message') if @budget_search.save

    flash.now[:notice] = t('search_failed_message')
    render 'new'
  end

  def show
    @search = BudgetSearch.find(params[:id])
    @distance = @search.distance
    @volume = @search.volume
    @weight = @search.weight
    @company_info = available_companies_info
  end

  private

  def budget_search_params
    params.require(:budget_search).permit(%i[height width depth weight distance])
  end

  def available_companies_info
    company_info = {}
    ShippingCompany.all.each do |company|
      delivery_time = company.delivery_time(distance: @distance)
      next if delivery_time.nil?

      value = company.value(volume: @volume, weight: @weight, distance: @distance)
      value.nil? ? next : value /= 100

      company_info[company] = { value: value, delivery_time: delivery_time }
    end
    company_info
  end
end
