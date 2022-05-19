class ShippingCompaniesController < ApplicationController
  def index
    @shipping_companies = ShippingCompany.all
  end

  def new
    @shipping_company = ShippingCompany.new
    @states = ShippingCompany::STATES
  end

  def create
    @shipping_company = ShippingCompany.new(shipping_company_params)
    if @shipping_company.save
      redirect_to @shipping_company, notice: 'Transportadora cadastrada com sucesso.'
    else
      @states = ShippingCompany::STATES
      flash.now[:notice] = 'Transportadora não cadastrada.'
      render 'new'
    end
  end

  def show
    @shipping_company = ShippingCompany.find(params[:id])
    @vehicles = @shipping_company.vehicles unless @shipping_company.vehicles.empty?
    @volume_ranges = @shipping_company.volume_ranges unless @shipping_company.volume_ranges.empty?
  end

  private

  def shipping_company_params
    params.require(:shipping_company).permit(:brand_name, :corporate_name, :registration_number, :email_domain,
                                             :address, :city, :state)
  end
end
