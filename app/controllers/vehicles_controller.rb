class VehiclesController < ApplicationController
  before_action :set_shipping_company

  def new
    @vehicle = Vehicle.new
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.shipping_company = @shipping_company
    if @vehicle.save
      redirect_to @shipping_company, notice: 'Veículo cadastrado com sucesso.'
    else
      flash.now[:notice] = 'Veículo não cadastrado.'
      render 'new'
    end
  end

  private

  def set_shipping_company
    @shipping_company = ShippingCompany.find(params[:shipping_company_id])
  end

  def vehicle_params
    params.require(:vehicle).permit(:license_plate, :model, :brand, :production_year,
                                    :maximum_load, :shipping_company)
  end
end
