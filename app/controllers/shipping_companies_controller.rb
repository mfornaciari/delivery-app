# frozen_string_literal: true

class ShippingCompaniesController < ApplicationController
  before_action :authenticate_user_or_admin, only: [:show]
  before_action :authenticate_admin!, only: %i[index new]

  def index
    @shipping_companies = ShippingCompany.all
  end

  def new
    @shipping_company = ShippingCompany.new
    @shipping_company.build_address
  end

  def create
    @shipping_company = ShippingCompany.new(shipping_company_params)
    return redirect_to @shipping_company, notice: t('company_creation_succeeded') if @shipping_company.save

    flash.now[:notice] = t('company_creation_failed')
    render 'new'
  end

  def show
    @shipping_company = ShippingCompany.find(params[:id])
    @vehicles = @shipping_company.vehicles unless @shipping_company.vehicles.empty?
    @volume_ranges = @shipping_company.volume_ranges unless @shipping_company.volume_ranges.empty?
    @price_distance_ranges = @shipping_company.price_distance_ranges if @shipping_company.price_distance_ranges.any?
    @time_distance_ranges = @shipping_company.time_distance_ranges if @shipping_company.time_distance_ranges.any?
    @back_path = admin_signed_in? ? shipping_companies_path : root_path
  end

  private

  def shipping_company_params
    params.require(:shipping_company).permit(:brand_name,
                                             :corporate_name,
                                             :registration_number,
                                             :email_domain,
                                             address_attributes: %i[line1 city state])
  end
end
