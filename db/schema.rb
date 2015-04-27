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

ActiveRecord::Schema.define(version: 20150423165722) do

  create_table "categories", force: :cascade do |t|
    t.string  "name"
    t.integer "parent_id"
    t.string  "canonical_name"
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "nzbs", force: :cascade do |t|
    t.integer "wish_result_id"
    t.binary  "blob"
  end

  add_index "nzbs", ["wish_result_id"], name: "index_nzbs_on_wish_result_id"

  create_table "settings", force: :cascade do |t|
    t.string  "newsnab_apikey"
    t.integer "result_limit"
    t.integer "search_interval"
    t.boolean "auto_download"
    t.boolean "fulfill_on_download"
    t.string  "sabnzbd_url"
    t.string  "sabnzbd_apikey"
    t.boolean "notify"
    t.string  "pushover_apikey"
    t.boolean "setup_complete"
    t.string  "newsnab_url"
  end

  create_table "wish_results", force: :cascade do |t|
    t.integer  "wish_id"
    t.string   "nzb_id",                                null: false
    t.string   "title",                                 null: false
    t.integer  "category_id"
    t.datetime "pub_date",                              null: false
    t.integer  "size",        limit: 8,                 null: false
    t.string   "details_url",                           null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "downloaded",            default: false, null: false
  end

  add_index "wish_results", ["category_id"], name: "index_wish_results_on_category_id"
  add_index "wish_results", ["nzb_id"], name: "index_wish_results_on_nzb_id"
  add_index "wish_results", ["wish_id"], name: "index_wish_results_on_wish_id"

  create_table "wishes", force: :cascade do |t|
    t.string   "name"
    t.string   "query"
    t.boolean  "fulfilled",         default: false, null: false
    t.integer  "category_id"
    t.datetime "last_search_date"
    t.datetime "start_search_date",                 null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "wishes", ["category_id"], name: "index_wishes_on_category_id"

end
