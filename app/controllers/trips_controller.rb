require 'json'

class TripsController < ApplicationController

  before_action :set_trip, only: [:show, :update, :destroy, :estimate]

  def create
    # debugger
    total_amt = total_amount(Date.parse(trip_params[:start]), Date.parse(trip_params[:start]) + trip_params[:duration].to_i, City.find(trip_params[:origin]), City.find(trip_params[:destination]), trip_params[:style].to_i)
    @trip = Trip.create!({
        origin: City.find(trip_params[:origin]),
        destination: City.find(trip_params[:destination]),
        start: Date.parse(trip_params[:start]),
        end: Date.parse(trip_params[:start]) + trip_params[:duration].to_i,
        style: trip_params[:style].to_i,
        total_amount: total_amt,
        saved_amount: 0
      })
    render json: @trip
  end

  def show
    render json: @trip
  end

  def update
    @trip.update!(trip_params)
    @trip.total_amount = estimate
  end

  def destroy
    @trip.destroy!
  end

  def estimate
    render json: { total: total_amount }
  end

  private

  def flight_cost(origin, destination, date)
    # debugger
    begin
      flight_cost = RestClient.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=" + ENV["GOOGLE_API_KEY"],
        {
          "request": {
            "slice": [
              {
                "origin": origin,
                "destination": destination,
                "date": date
              }
            ],
            "passengers": {
              "adultCount": 1,
              "infantInLapCount": 0,
              "infantInSeatCount": 0,
              "childCount": 0,
              "seniorCount": 0
            },
            "solutions": 1,
            "refundable": false
          }
        }.to_json, {
            content_type: :json
          }
        )
        flight_cost = JSON.parse(flight_cost)["trips"]["tripOption"][0]["saleTotal"]
        if flight_cost
          flight_cost = flight_cost.gsub(/[a-zA-Z]/, "").to_i
        else
          0
        end
    rescue => e
      puts(e.response)
      render status: 500
    end

  end

  def trip_params
    params.permit(:origin, :destination, :start, :duration, :style, :saved_amount)
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def average_city_daily_cost(destination)
    city_url = destination.url

    res = RestClient.get('https://nomadlist.com/api/v2/list/cities/'+ city_url, headers={})
    json = JSON.parse(res.body)
    cost = json["result"][0]["cost"]["nomad"]["USD"].to_i / 30
  end

  def total_amount(t_start, t_end, origin, destination, style)
    # debugger
    duration = (t_end - t_start).to_i
    per_day_cost = average_city_daily_cost(destination)

    total_flight_cost = flight_cost(origin.airport, destination.airport, t_start.to_s) +
                        flight_cost(destination.airport, origin.airport, t_end.to_s)
    (per_day_cost * duration + total_flight_cost) * (0.7 + 0.3 * (style - 1))
  end
end
