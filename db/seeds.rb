# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'json'
require 'rest-client'
require 'benchmark'

#returns list of available cities
def cities
  res = RestClient.get('https://nomadlist.com/api/v2/list/cities/', headers={})
  dict = JSON.parse(res.body)
  dict["result"].map{ |item| item["info"]["city"]}
end

airports = JSON.parse(File.read('db/data/airports.json')).uniq!{|airport| airport["city"]}
saved_cities = cities

airports.each do |airport|
  saved_cities.each do |city|
    if airport["city"] == city["name"]
      hello = City.create({
        name: airport["city"],
        country: airport["country"],
        airport: airport["code"],
        url: city["url"]
        })
      puts hello.id
    end
  end
end

Trip.create({
  origin_id: City.where(name: "Montreal").first.id,
  destination_id: City.where(name: "Tokyo").first.id,
  start: Date.new(2016, 3, 12),
  end: Date.new(2016, 4, 12),
  style: rand(1..3),
  saved_amount: 0.0,
  total_amount: 0.0
  })
