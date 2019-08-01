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

ActiveRecord::Schema.define(version: 2019_08_01_091615) do

  create_table "clubs", force: :cascade do |t|
    t.string "name"
  end

  create_table "fans", force: :cascade do |t|
    t.string "name"
    t.boolean "season_ticket_holder"
  end

  create_table "player_fans", force: :cascade do |t|
    t.integer "player_id"
    t.integer "fan_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "age"
    t.string "position"
    t.string "market_value"
    t.string "nationality"
    t.integer "club_id"
  end

end
