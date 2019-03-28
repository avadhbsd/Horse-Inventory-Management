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

ActiveRecord::Schema.define(version: 2019_03_27_103737) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.string "type"
    t.string "full_name"
    t.json "roles"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "inventory_items", force: :cascade do |t|
    t.bigint "product_variant_id"
    t.bigint "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_variant_id"], name: "index_inventory_items_on_product_variant_id"
    t.index ["store_id"], name: "index_inventory_items_on_store_id"
  end

  create_table "inventory_levels", force: :cascade do |t|
    t.integer "quantity"
    t.bigint "location_id"
    t.bigint "inventory_item_id"
    t.bigint "shared_inventory_level_id"
    t.bigint "store_id"
    t.bigint "product_variant_id"
    t.bigint "shared_product_variant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_item_id"], name: "index_inventory_levels_on_inventory_item_id"
    t.index ["location_id"], name: "index_inventory_levels_on_location_id"
    t.index ["product_variant_id"], name: "index_inventory_levels_on_product_variant_id"
    t.index ["shared_inventory_level_id"], name: "index_inventory_levels_on_shared_inventory_level_id"
    t.index ["shared_product_variant_id"], name: "index_inventory_levels_on_shared_product_variant_id"
    t.index ["store_id"], name: "index_inventory_levels_on_store_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "quantity"
    t.integer "fulfillable_quantity"
    t.string "fulfillment_status"
    t.bigint "product_id"
    t.bigint "shared_product_id"
    t.bigint "product_variant_id"
    t.bigint "shared_product_variant_id"
    t.bigint "order_id"
    t.bigint "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
    t.index ["product_variant_id"], name: "index_line_items_on_product_variant_id"
    t.index ["shared_product_id"], name: "index_line_items_on_shared_product_id"
    t.index ["shared_product_variant_id"], name: "index_line_items_on_shared_product_variant_id"
    t.index ["store_id"], name: "index_line_items_on_store_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "title"
    t.string "phone"
    t.string "address1"
    t.string "address2"
    t.string "country_code"
    t.string "country"
    t.string "city"
    t.string "province"
    t.string "province_code"
    t.string "zip"
    t.boolean "active"
    t.bigint "store_id"
    t.bigint "shared_location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shared_location_id"], name: "index_locations_on_shared_location_id"
    t.index ["store_id"], name: "index_locations_on_store_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "financial_status"
    t.string "fulfillment_status"
    t.datetime "cancelled_at"
    t.datetime "closed_at"
    t.bigint "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_orders_on_store_id"
  end

  create_table "product_variants", force: :cascade do |t|
    t.string "title"
    t.float "price"
    t.bigint "product_id"
    t.bigint "store_id"
    t.bigint "shared_product_variant_id"
    t.bigint "shared_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_variants_on_product_id"
    t.index ["shared_product_id"], name: "index_product_variants_on_shared_product_id"
    t.index ["shared_product_variant_id"], name: "index_product_variants_on_shared_product_variant_id"
    t.index ["store_id"], name: "index_product_variants_on_store_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.bigint "shared_product_id"
    t.bigint "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shared_product_id"], name: "index_products_on_shared_product_id"
    t.index ["store_id"], name: "index_products_on_store_id"
  end

  create_table "shared_inventory_levels", force: :cascade do |t|
    t.integer "quantity"
    t.bigint "shared_location_id"
    t.bigint "shared_product_variant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shared_location_id"], name: "index_shared_inventory_levels_on_shared_location_id"
    t.index ["shared_product_variant_id"], name: "index_shared_inventory_levels_on_shared_product_variant_id"
  end

  create_table "shared_locations", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shared_product_variants", force: :cascade do |t|
    t.string "title"
    t.string "sku"
    t.bigint "shared_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shared_product_id"], name: "index_shared_product_variants_on_shared_product_id"
  end

  create_table "shared_products", force: :cascade do |t|
    t.string "title"
    t.string "vendor"
    t.string "product_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.string "url"
    t.text "encrypted_api_key"
    t.text "encrypted_api_pass"
    t.text "encrypted_secret"
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "encrypted_webhook_signature"
  end

  add_foreign_key "inventory_items", "product_variants"
  add_foreign_key "inventory_items", "stores"
  add_foreign_key "inventory_levels", "inventory_items"
  add_foreign_key "inventory_levels", "locations"
  add_foreign_key "inventory_levels", "product_variants"
  add_foreign_key "inventory_levels", "shared_inventory_levels"
  add_foreign_key "inventory_levels", "shared_product_variants"
  add_foreign_key "inventory_levels", "stores"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "product_variants"
  add_foreign_key "line_items", "products"
  add_foreign_key "line_items", "shared_product_variants"
  add_foreign_key "line_items", "shared_products"
  add_foreign_key "line_items", "stores"
  add_foreign_key "locations", "shared_locations"
  add_foreign_key "locations", "stores"
  add_foreign_key "orders", "stores"
  add_foreign_key "product_variants", "products"
  add_foreign_key "product_variants", "shared_product_variants"
  add_foreign_key "product_variants", "shared_products"
  add_foreign_key "product_variants", "stores"
  add_foreign_key "products", "shared_products"
  add_foreign_key "products", "stores"
  add_foreign_key "shared_inventory_levels", "shared_locations"
  add_foreign_key "shared_inventory_levels", "shared_product_variants"
  add_foreign_key "shared_product_variants", "shared_products"
end
