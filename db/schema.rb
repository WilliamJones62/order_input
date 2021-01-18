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

ActiveRecord::Schema.define(version: 20201113161605) do

  create_table "current_prices", force: :cascade do |t|
    t.string "part_code"
    t.float "part_wt"
    t.string "part_uom"
    t.float "part_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customer_shiptos", force: :cascade do |t|
    t.string "cust_code"
    t.string "shipto_code"
    t.boolean "default_flag"
    t.string "acct_manager"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bus_name"
  end

  create_table "employees", force: :cascade do |t|
    t.string "Badge_"
    t.string "FirstName"
    t.string "Lastname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fs_focus_items", force: :cascade do |t|
    t.string "team"
    t.string "rep"
    t.string "customer"
    t.string "part_code"
    t.string "part_desc"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fs_order_parts", force: :cascade do |t|
    t.integer "fs_order_id"
    t.string "partcode"
    t.integer "qty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "partdesc"
    t.string "uom"
    t.boolean "new_part"
  end

  create_table "fs_order_test_parts", force: :cascade do |t|
    t.integer "fs_order_id"
    t.string "partcode"
    t.integer "qty"
    t.string "part_desc"
    t.string "uom"
    t.boolean "new_part"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "partdesc"
    t.integer "fs_order_test_id"
  end

  create_table "fs_order_tests", force: :cascade do |t|
    t.string "customer"
    t.string "shipto"
    t.date "date_required"
    t.string "rep"
    t.string "status"
    t.string "cancel_rep"
    t.date "cancel_date"
    t.string "po_number"
    t.text "notes"
    t.boolean "order_entered"
    t.boolean "second_run"
    t.string "dp"
    t.string "order_num"
    t.boolean "in_process"
    t.string "rep_name"
    t.string "cut_off"
    t.date "next_schedueled_delivery"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fs_orders", force: :cascade do |t|
    t.string "customer"
    t.string "shipto"
    t.date "date_required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rep"
    t.string "status"
    t.string "cancel_rep"
    t.date "cancel_date"
    t.string "po_number"
    t.text "notes"
    t.boolean "order_entered"
    t.boolean "second_run"
    t.string "dp"
    t.string "order_num"
    t.boolean "in_process"
    t.string "rep_name"
    t.string "cut_off"
    t.date "next_schedueled_delivery"
    t.string "acct_manager"
  end

  create_table "lateorderscustomercos", force: :cascade do |t|
    t.string "cust_code"
    t.string "shipto_code"
    t.string "route_code"
    t.datetime "cutoff_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oecusbuys", force: :cascade do |t|
    t.string "cust_code"
    t.string "part_code"
    t.integer "item_no"
    t.integer "hist_qty"
    t.integer "ord_qty"
    t.string "uom"
    t.date "last_ord_date"
    t.date "last_ship_date"
    t.string "po_vend_code"
    t.date "item_outdate"
    t.date "duedate"
    t.string "up_all_dates"
    t.string "uom_conv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orderfroms", force: :cascade do |t|
    t.string "cust_code"
    t.string "bus_name"
    t.string "cust_group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sales_type"
  end

  create_table "ordheads", force: :cascade do |t|
    t.string "order_numb"
    t.string "rel_numb"
    t.date "order_date"
    t.string "cust_code"
    t.string "cust_name"
    t.string "cust_po"
    t.string "shipto_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orditems", force: :cascade do |t|
    t.string "order_numb"
    t.string "rel_numb"
    t.string "part_code"
    t.string "part_desc"
    t.string "uom"
    t.integer "qty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "partmstrs", force: :cascade do |t|
    t.string "part_code"
    t.string "part_desc"
    t.string "part_grp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uom"
    t.string "part_status"
  end

  create_table "routecodes", force: :cascade do |t|
    t.string "route_code"
    t.boolean "monday"
    t.boolean "tuesday"
    t.boolean "wednesday"
    t.boolean "thursday"
    t.boolean "friday"
    t.boolean "saturday"
    t.boolean "sunday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shiptos", force: :cascade do |t|
    t.string "shipto_code"
    t.string "route_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rep1"
    t.string "rep2"
    t.string "rep3"
    t.boolean "retail"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
