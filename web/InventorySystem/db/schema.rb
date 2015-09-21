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

ActiveRecord::Schema.define(version: 20150919054858) do

  create_table "inventories", force: :cascade do |t|
    t.string   "department",        limit: 255,                 null: false
    t.string   "position",          limit: 255,                 null: false
    t.string   "part",              limit: 255,                 null: false
    t.string   "part_type",         limit: 255,                 null: false
    t.float    "check_qty",         limit: 24
    t.string   "check_user",        limit: 255
    t.datetime "check_time"
    t.float    "random_check_qty",  limit: 24
    t.string   "random_check_user", limit: 255
    t.datetime "random_check_time"
    t.boolean  "is_random_check",               default: false
    t.string   "ios_created_id",    limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "nr",         limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
