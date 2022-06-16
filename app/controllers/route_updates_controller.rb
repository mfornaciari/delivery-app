# frozen_string_literal: true

class RouteUpdatesController < ApplicationController
  def create
    @route_update = RouteUpdate.new(route_update_params)
    @route_update.order = Order.find(params[:order_id])
    return redirect_to @route_update.order, notice: t('route_update_succeeded_message') if @route_update.save

    @order = @route_update.order
    flash.now[:notice] = t('route_update_failed_message')
    render 'orders/show'
  end

  private

  def route_update_params
    params.require(:route_update).permit(%i[latitude longitude date_and_time])
  end
end
