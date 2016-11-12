require 'json'
class TripsController < ApplicationController

  before_action :set_trip, only: [:show, :update, :destroy, :estimate]

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


  def estimate
    duration = (@trip.end - @trip.start)
    per_day_cost = average_city_cost(@trip)

    total_flight_cost = flight_cost(@trip.origin.airport, @trip.destination.airport, @trip.start.to_s) +
                        flight_cost(@trip.destination.airport, @trip.origin.airport, @trip.end.to_s)
    per_day_cost * duration + total_flight_cost
  end

  private

  def flight_cost(origin, destination, date)
    flight_cost = RestClient.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=" + ENV["GOOGLE_API_KEY"],
      {
        "request": {
          "passengers": {
            "adultCount": "1"
          },
          "slice": [
            {
              "origin": origin,
              "destination": destination,
              "date": date
            }
          ],
          "solutions": "1"
        }
      }.to_json)["trips"]["tripOption"]["saleTotal"]

    flight_cost.gsub(/[a-zA-Z]/, "").to_i
  end

  def trip_params
    params.require(:trip).permit(:origin, :destination, :start, :end, :style, :saved_amount, :total_amount)
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def average_city_cost(trip)
    city_url = trip.destination.url

    res = RestClient.get('https://nomadlist.com/api/v2/list/cities/'+ city_url, headers={})
    json = JSON.parse(res.body)
    cost = json["result"][0]["cost"]["nomad"]["USD"]
    render json: { "cost": cost }
  end
end
