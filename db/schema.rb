# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161112015912) do

  create_table "cities", force: :cascade do |t|
    t.integer  "trip_id"
    t.string   "name"
    t.string   "country"
    t.string   "airport"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cities", ["trip_id"], name: "index_cities_on_trip_id"

  create_table "trips", force: :cascade do |t|
    t.integer  "origin_id"
    t.integer  "destination_id"
    t.date     "start"
    t.date     "end"
    t.integer  "style"
    t.decimal  "saved_amount"
    t.decimal  "total_amount"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
