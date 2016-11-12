# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


5.times {
  Trip.create({
    origin: "YUL",
    destination: "LAX",
    start: Date.new(2016, 3, 12),
    end: Date.new(2016, 4, 12),
    style: rand(1..3),
    saved_amount: 0.0,
    total_amount: 0.0
    })
}