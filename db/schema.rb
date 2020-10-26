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

ActiveRecord::Schema.define(version: 2020_10_22_123137) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "consignments", force: :cascade do |t|
    t.date "ship_date"
    t.string "customer_code"
    t.string "product_code"
    t.string "serial_number"
    t.string "note"
    t.integer "quantity", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "customer_name"
    t.integer "customer_id_number", null: false
    t.string "product_name"
    t.integer "product_id_number", null: false
    t.boolean "done", default: false, null: false
    t.string "user_name", null: false
    t.index ["user_id"], name: "index_consignments_on_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "code", default: "", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_customers_on_code", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.integer "month_day"
    t.string "month_notice"
    t.integer "year_month"
    t.integer "year_day"
    t.string "year_notice"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "month_check", default: false, null: false
    t.boolean "year_check", default: false, null: false
    t.integer "reminder_month"
    t.string "reminder_notice"
    t.boolean "reminder_check", default: false, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "code", default: "", null: false
    t.string "name"
    t.string "classification"
    t.string "category"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_products_on_code", unique: true
  end

  create_table "stocks", force: :cascade do |t|
    t.integer "return_quantity", default: 0, null: false
    t.integer "sales_quantity", default: 0, null: false
    t.integer "consignment_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "processing_date"
    t.index ["consignment_id"], name: "index_stocks_on_consignment_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.integer "code", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "consignments", "users"
  add_foreign_key "stocks", "consignments"
end
