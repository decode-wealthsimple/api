require 'rest-client'

class Trip < ActiveRecord::Base
  validates :origin, :destination, :start, :end, presence: true
  validates :style, inclusion: 1..3
  validates :saved_amount, :total_amount, numericality: {greater_than_or_equal_to: 0}

  def estimate
    duration = (self.end - self.start)
    per_day_cost = RestClient.get("http://localhost:3000/nomad/cities/" + self.destination + "/cost", headers={}).to_i / 30

    #PLANES
    flight_cost = RestClient.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=" + ENV["GOOGLE_API_KEY"],
      {
        "request": {
          "passengers": {
            "adultCount": "1"
          },
          "slice": [
            {
              "origin": "YUL",
              "destination": "LAX",
              "date": "2017-09-19"
            }
          ],
          "solutions": "1"
        }
      }.to_json)["trips"]["tripOption"]["saleTotal"]

    flight_cost = flight_cost.gsub(/[a-zA-Z]/, "").to_i

    per_day_cost * duration + flight_cost
  end

  def deposit(amount)
    self.saved_amount += amount
  end

  def withdraw(amount)
    self.saved_amount -= amount
  end



end
