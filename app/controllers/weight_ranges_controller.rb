class WeightRangesController < ApplicationController
  before_action :check_user_login
  before_action :set_volume_range, only: %i[new create]

  def new
    @weight_range = WeightRange.new
  end

  def create
    @weight_range = WeightRange.new(weight_range_params)
    @weight_range.volume_range = @volume_range
    if @weight_range.save
      redirect_to edit_volume_range_path(@volume_range), notice: 'Intervalo cadastrado com sucesso.'
    else
      flash.now[:notice] = 'Intervalo não cadastrado.'
      render 'new'
    end
  end

  private

  def set_volume_range
    @volume_range = VolumeRange.find(params[:volume_range_id])
  end

  def weight_range_params
    params.require(:weight_range).permit(:min_weight, :max_weight, :value)
  end

  def check_user_login
    authenticate_user! unless admin_signed_in?
  end
end
