class HomeController < ApplicationController
  def index
    @budget_searches = BudgetSearch.all if admin_signed_in?
  end
end
