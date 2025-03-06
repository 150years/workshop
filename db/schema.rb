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

ActiveRecord::Schema[8.0].define(version: 2025_03_04_191456) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agents", force: :cascade do |t|
    t.string "name", null: false
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_agents_on_company_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.index ["company_id", "email"], name: "index_clients_on_company_id_and_email"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "components", force: :cascade do |t|
    t.integer "company_id"
    t.string "code", null: false
    t.string "name", null: false
    t.string "color"
    t.integer "unit", null: false
    t.integer "width"
    t.integer "length"
    t.integer "weight"
    t.integer "min_quantity", default: 0, null: false
    t.integer "price", default: 0, null: false
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_components_on_company_id"
  end

  create_table "order_versions", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "total_amount", default: 0, null: false
    t.integer "agent_comm", default: 0, null: false
    t.text "comment"
    t.text "version_note"
    t.boolean "final_version", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id", null: false
    t.index ["company_id"], name: "index_order_versions_on_company_id"
    t.index ["order_id"], name: "index_order_versions_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "client_id", null: false
    t.integer "agent_id", null: false
    t.string "name"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_orders_on_agent_id"
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["company_id"], name: "index_orders_on_company_id"
  end

  create_table "product_components", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "component_id", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["component_id"], name: "index_product_components_on_component_id"
    t.index ["product_id"], name: "index_product_components_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.integer "width", default: 0, null: false
    t.integer "height", default: 0, null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_version_id"
    t.integer "company_id", null: false
    t.integer "price", default: 0, null: false
    t.index ["company_id"], name: "index_products_on_company_id"
    t.index ["order_version_id"], name: "index_products_on_order_version_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.integer "company_id", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "agents", "companies"
  add_foreign_key "clients", "companies"
  add_foreign_key "components", "companies"
  add_foreign_key "order_versions", "companies"
  add_foreign_key "order_versions", "orders"
  add_foreign_key "orders", "agents"
  add_foreign_key "orders", "clients"
  add_foreign_key "orders", "companies"
  add_foreign_key "product_components", "components"
  add_foreign_key "product_components", "products"
  add_foreign_key "products", "companies"
  add_foreign_key "products", "order_versions"
  add_foreign_key "users", "companies"
end
