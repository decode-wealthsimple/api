class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :update, :destroy]

  def create
    @trip = Trip.create!(trip_params)
    render json: @trip
  end

  def show
    render json: @trip
  end

  def update
    @trip.update!(trip_params)
  end

  def destroy
    @trip.destroy!
  end

  private

  def trip_params
    params.require(:trip).permit(:origin, :destination, :start, :end, :style, :saved_amount, :total_amount)
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end
end
