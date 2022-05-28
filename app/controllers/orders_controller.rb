class OrdersController < ApplicationController
  def new
    if params[:search_id].nil?
      return redirect_to root_path, notice: 'Antes de criar um pedido, faça uma consulta de preços.'
    end

    @search = BudgetSearch.find params[:search_id]
    return redirect_to @search, notice: 'Selecione uma transportadora.' if params[:shipping_company_id].empty?

    @shipping_company = ShippingCompany.find params[:shipping_company_id]
    @price = price(@shipping_company, @search.volume, @search.weight, @search.distance)
    @delivery_time = delivery_time(@shipping_company, @search.distance)
    @order = Order.new
    @states = Order::STATES
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to @order, notice: 'Pedido cadastrado com sucesso.'
    else
      @search = BudgetSearch.find params[:search_id]
      flash.now[:notice] = 'Pedido não cadastrado.'
      render 'new'
    end
  end

  def show
    @order = Order.find params[:id]
  end

  private

  def order_params
    params.require(:order).permit(%i[volume weight distance pickup_address pickup_city pickup_state
                                     delivery_address delivery_city delivery_state recipient_name product_code
                                     estimated_delivery_time value shipping_company_id])
  end

  def delivery_time(company, distance)
    company.time_distance_ranges.find_by('min_distance <= :distance AND max_distance >= :distance',
                                         distance:).delivery_time
  end

  def price(company, volume, weight, distance)
    price = WeightRange.joins(:volume_range).find_by(
      'min_weight <= :weight AND max_weight >= :weight AND
      volume_ranges.min_volume <= :volume AND volume_ranges.max_volume >= :volume AND
      volume_ranges.shipping_company_id = :company_id',
      volume:, weight:, company_id: company.id
    ).value * distance
    min_price = min_price(company, distance)
    min_price && price < min_price ? min_price : price
  end

  def min_price(company, distance)
    company.price_distance_ranges.find_by('min_distance <= :distance AND max_distance >= :distance',
                                          distance:)&.value
  end
end
