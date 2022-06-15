class OrdersController < ApplicationController
  before_action :authenticate_admin!, only: :new
  before_action :authenticate_user_or_admin, only: %i[index show]

  def index
    @company = user_signed_in? ? current_user.shipping_company : ShippingCompany.find(params[:shipping_company])
    @orders = @company.orders
  end

  def new
    return redirect_to root_path, notice: t('direct_creation_attempt_message') unless params_exist

    @order = Order.new(params.permit(%i[shipping_company_id volume weight distance value
                                        estimated_delivery_time]))
    @states = Order::STATES
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to @order, notice: t('order_creation_succeeded_message')
    else
      @states = Order::STATES
      flash.now[:notice] = t('order_creation_failed_message')
      render 'new'
    end
  end

  def show
    @order = Order.find params[:id]
    @route_updates = @order.route_updates
    @route_update = RouteUpdate.new
  end

  def accepted
    @order = Order.find params[:id]
    return redirect_to @order, notice: t('must_set_vehicle_message') if params[:vehicle_id].empty?

    @order.accepted!
    vehicle = Vehicle.find params[:vehicle_id]
    @order.update vehicle: vehicle
    redirect_to @order, notice: t('order_accepted_message')
  end

  def rejected
    @order = Order.find params[:id]
    @order.rejected!
    redirect_to @order, notice: t('order_rejected_message')
  end

  def finished
    @order = Order.find params[:id]
    @order.finished!
    redirect_to @order, notice: t('order_finished_message')
  end

  def search
    @order = Order.find_by code: params[:query], status: %i[accepted finished]
    redirect_to root_path, notice: t('no_such_order_message') if @order.nil?
  end

  private

  def order_params
    params.require(:order).permit(%i[shipping_company_id volume weight distance estimated_delivery_time value
                                     pickup_address pickup_city pickup_state delivery_address delivery_city
                                     delivery_state recipient_name product_code])
  end

  def params_exist
    %i[shipping_company_id volume weight distance value estimated_delivery_time].each do |key|
      return false if params[key].nil?
    end
    true
  end
end
