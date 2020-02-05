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

ActiveRecord::Schema.define(version: 2020_02_05_143300) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "test_criteria", force: :cascade do |t|
    t.string "url"
    t.integer "max_ttfb"
    t.integer "max_tti"
    t.integer "max_speed_index"
    t.integer "max_ttfp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_results", force: :cascade do |t|
    t.bigint "test_criterium_id"
    t.integer "ttfb"
    t.integer "tti"
    t.integer "speed_index"
    t.boolean "passed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_criterium_id"], name: "index_test_results_on_test_criterium_id"
  end

  add_foreign_key "test_results", "test_criteria"
end
