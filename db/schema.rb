# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_08_04_131134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.decimal "latitude", precision: 7, scale: 5
    t.decimal "longitude", precision: 7, scale: 5
    t.text "weights"
    t.integer "age_restriction"
    t.boolean "is_open"
    t.string "owner"
    t.bigint "business_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_id"], name: "index_items_on_business_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.decimal "latitude", precision: 7, scale: 5
    t.decimal "longitude", precision: 7, scale: 5
    t.text "weights"
    t.date "birthday"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "items", "items", column: "business_id"
end
