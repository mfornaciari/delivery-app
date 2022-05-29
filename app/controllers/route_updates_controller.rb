class RouteUpdatesController < ApplicationController
  def create
    @route_update = RouteUpdate.new(route_update_params)
    @route_update.order = Order.find params[:order_id]
    if @route_update.save
      redirect_to @route_update.order, notice: 'Rota de entrega do pedido atualizada.'
    else
      @order = @route_update.order
      @route_updates = @order.route_updates
      flash.now[:notice] = 'Rota de entrega não atualizada.'
      render 'orders/show'
    end
  end

  private

  def route_update_params
    params.require(:route_update).permit(%i[latitude longitude date_and_time])
  end
end
