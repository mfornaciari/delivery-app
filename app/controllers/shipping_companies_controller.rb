class ShippingCompaniesController < ApplicationController
  def index
    @shipping_companies = ShippingCompany.all
  end

  def show
    @shipping_company = ShippingCompany.find(params[:id])
  end
end
