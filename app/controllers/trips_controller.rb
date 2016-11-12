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
    duration = (@trip.end - @trip.start).to_i
    per_day_cost = average_city_cost(@trip)

    #PLANES
    begin
      flight_cost = RestClient.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=" + ENV["GOOGLE_API_KEY"],
        {
          "request": {
            "slice": [
              {
                "origin": @trip.origin.airport,
                "destination": @trip.destination.airport,
                "date": "2016-12-02"
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
        total_amount = { total: per_day_cost * duration + flight_cost }
        puts total_amount
      end
      render json: total_amount
    rescue => e
      puts(e.response)
      render status: 500
    end

    
  end

private

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
    cost.to_i
  end
end
