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

ActiveRecord::Schema.define(version: 20140723122646) do

  create_table "projects", force: true do |t|
    t.integer  "remote_id"
    t.integer  "site"
    t.string   "title"
    t.text     "body"
    t.string   "uri",             null: false
    t.string   "category"
    t.string   "budget_origin"
    t.integer  "budget_amount"
    t.string   "budget_currency"
    t.datetime "published"
    t.datetime "viewed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
