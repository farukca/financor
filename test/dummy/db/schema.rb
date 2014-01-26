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

ActiveRecord::Schema.define(version: 20140117211254) do

  create_table "financor_budgetlines", force: true do |t|
    t.string   "name",                                         null: false
    t.string   "line_type",     limit: 20,                     null: false
    t.integer  "company_id"
    t.decimal  "amount",                    default: 0.0
    t.string   "curr",          limit: 3,                      null: false
    t.string   "item_type",     limit: 30
    t.string   "budgeted_type", limit: 100
    t.integer  "budgeted_id"
    t.string   "status",        limit: 10,  default: "active"
    t.text     "notes",         limit: 500
    t.integer  "user_id",                                      null: false
    t.integer  "patron_id",                                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
