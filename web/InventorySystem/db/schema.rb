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

ActiveRecord::Schema.define(version: 20160614093947) do

  create_table "file_tasks", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "data_file_id", limit: 4
    t.integer  "err_file_id",  limit: 4
    t.integer  "status",       limit: 4
    t.string   "remark",       limit: 255
    t.integer  "type",         limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "file_tasks", ["user_id"], name: "index_file_tasks_on_user_id", using: :btree

  create_table "inventories", force: :cascade do |t|
    t.string   "department",        limit: 255,                 null: false
    t.string   "position",          limit: 255,                 null: false
    t.string   "part_nr",           limit: 255,                 null: false
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
    t.integer  "sn",                limit: 4
    t.string   "part_unit",         limit: 255
    t.string   "part_type",         limit: 255
    t.string   "wire_nr",           limit: 255
    t.string   "process_nr",        limit: 255
  end

  add_index "inventories", ["part_nr"], name: "index_inventories_on_part_nr", using: :btree
  add_index "inventories", ["position"], name: "index_inventories_on_position", using: :btree

  create_table "inventory_data", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "path",       limit: 255
    t.string   "size",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "inventory_files", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "path",       limit: 255
    t.string   "size",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "parts", force: :cascade do |t|
    t.string   "nr",         limit: 255
    t.string   "type",       limit: 255
    t.string   "unit",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "value",      limit: 255
    t.string   "code",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "nr",         limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "role",       limit: 255
    t.string   "id_span",    limit: 255
  end

  add_foreign_key "file_tasks", "users"
end
