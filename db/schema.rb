# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_06_16_104706) do
  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "budget_searches", force: :cascade do |t|
    t.integer "height"
    t.integer "width"
    t.integer "depth"
    t.integer "weight"
    t.integer "distance"
    t.integer "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "volume"
    t.index ["admin_id"], name: "index_budget_searches_on_admin_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "pickup_address"
    t.string "delivery_address"
    t.string "recipient_name"
    t.string "product_code"
    t.integer "volume"
    t.integer "weight"
    t.integer "distance"
    t.integer "status", default: 0
    t.string "code"
    t.integer "shipping_company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pickup_city"
    t.string "pickup_state"
    t.string "delivery_city"
    t.string "delivery_state"
    t.integer "estimated_delivery_time"
    t.integer "value"
    t.integer "search_id"
    t.integer "vehicle_id"
    t.index ["shipping_company_id"], name: "index_orders_on_shipping_company_id"
    t.index ["vehicle_id"], name: "index_orders_on_vehicle_id"
  end

  create_table "price_distance_ranges", force: :cascade do |t|
    t.integer "min_distance"
    t.integer "max_distance"
    t.integer "value"
    t.integer "shipping_company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_company_id"], name: "index_price_distance_ranges_on_shipping_company_id"
  end

  create_table "route_updates", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.datetime "date_and_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_id", null: false
    t.index ["order_id"], name: "index_route_updates_on_order_id"
  end

  create_table "shipping_companies", force: :cascade do |t|
    t.string "brand_name"
    t.string "corporate_name"
    t.string "email_domain"
    t.integer "registration_number"
    t.string "address"
    t.string "city"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_number"], name: "index_shipping_companies_on_registration_number", unique: true
  end

  create_table "time_distance_ranges", force: :cascade do |t|
    t.integer "min_distance"
    t.integer "max_distance"
    t.integer "delivery_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shipping_company_id", null: false
    t.index ["shipping_company_id"], name: "index_time_distance_ranges_on_shipping_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "shipping_company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["shipping_company_id"], name: "index_users_on_shipping_company_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "license_plate"
    t.string "brand"
    t.string "model"
    t.integer "production_year"
    t.integer "maximum_load"
    t.integer "shipping_company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["license_plate"], name: "index_vehicles_on_license_plate", unique: true
    t.index ["shipping_company_id"], name: "index_vehicles_on_shipping_company_id"
  end

  create_table "volume_ranges", force: :cascade do |t|
    t.integer "shipping_company_id", null: false
    t.integer "min_volume"
    t.integer "max_volume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_company_id"], name: "index_volume_ranges_on_shipping_company_id"
  end

  create_table "weight_ranges", force: :cascade do |t|
    t.integer "volume_range_id", null: false
    t.integer "min_weight"
    t.integer "max_weight"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["volume_range_id"], name: "index_weight_ranges_on_volume_range_id"
  end

  add_foreign_key "budget_searches", "admins"
  add_foreign_key "orders", "shipping_companies"
  add_foreign_key "orders", "vehicles"
  add_foreign_key "price_distance_ranges", "shipping_companies"
  add_foreign_key "route_updates", "orders"
  add_foreign_key "time_distance_ranges", "shipping_companies"
  add_foreign_key "vehicles", "shipping_companies"
  add_foreign_key "volume_ranges", "shipping_companies"
  add_foreign_key "weight_ranges", "volume_ranges"
end
