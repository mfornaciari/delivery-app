class VehiclesController < ApplicationController
  before_action :authenticate_user_or_admin
  before_action :set_shipping_company

  def new
    @vehicle = Vehicle.new
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.shipping_company = @shipping_company
    return redirect_to @shipping_company, notice: t('vehicle_creation_succeeded') if @vehicle.save

    flash.now[:notice] = t('vehicle_creation_failed')
    render 'new'
  end

  private

  def vehicle_params
    params.require(:vehicle).permit(%i[license_plate model brand production_year maximum_load])
  end
end
