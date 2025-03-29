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

ActiveRecord::Schema[8.0].define(version: 2025_03_29_050714) do
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
    t.string "phone"
    t.string "email"
    t.integer "commission"
    t.index ["company_id"], name: "index_agents_on_company_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "address"
    t.string "tax_id"
    t.string "phone"
    t.index ["company_id", "email"], name: "index_clients_on_company_id_and_email"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "currency", default: "THB", null: false
  end

  create_table "components", force: :cascade do |t|
    t.integer "company_id"
    t.string "code", null: false
    t.string "name", null: false
    t.string "color"
    t.integer "unit", null: false
    t.decimal "width", precision: 7, scale: 1
    t.decimal "length", precision: 7, scale: 1
    t.decimal "weight", precision: 7, scale: 1
    t.decimal "min_quantity", precision: 7, scale: 1
    t.integer "price_cents", default: 0, null: false
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "thickness", precision: 7, scale: 1
    t.decimal "height", precision: 7, scale: 1
    t.integer "category", default: 0, null: false
    t.index ["company_id"], name: "index_components_on_company_id"
  end

  create_table "entries", force: :cascade do |t|
    t.string "number"
    t.date "date", null: false
    t.string "subject"
    t.string "accountable_type"
    t.integer "accountable_id"
    t.text "note"
    t.boolean "permanent", default: false, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "project_id"
    t.integer "order_version_id"
    t.integer "order_id", default: 0, null: false
    t.index ["accountable_type", "accountable_id"], name: "index_entries_on_accountable_type_and_accountable_id"
    t.index ["date"], name: "index_entries_on_date"
    t.index ["order_id"], name: "index_entries_on_order_id"
    t.index ["order_version_id"], name: "index_entries_on_order_version_id"
    t.index ["project_id"], name: "index_entries_on_project_id"
  end

  create_table "keepr_accounts", force: :cascade do |t|
    t.integer "number", null: false
    t.string "ancestry"
    t.string "name", null: false
    t.integer "kind", null: false
    t.integer "keepr_group_id"
    t.string "accountable_type"
    t.integer "accountable_id"
    t.integer "keepr_tax_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["accountable_type", "accountable_id"], name: "index_keepr_accounts_on_accountable_type_and_accountable_id"
    t.index ["ancestry"], name: "index_keepr_accounts_on_ancestry"
    t.index ["keepr_group_id"], name: "index_keepr_accounts_on_keepr_group_id"
    t.index ["keepr_tax_id"], name: "index_keepr_accounts_on_keepr_tax_id"
    t.index ["number"], name: "index_keepr_accounts_on_number"
  end

  create_table "keepr_cost_centers", force: :cascade do |t|
    t.string "number", null: false
    t.string "name", null: false
    t.text "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keepr_groups", force: :cascade do |t|
    t.integer "target", null: false
    t.string "number"
    t.string "name", null: false
    t.boolean "is_result", default: false, null: false
    t.string "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["ancestry"], name: "index_keepr_groups_on_ancestry"
  end

  create_table "keepr_postings", force: :cascade do |t|
    t.integer "keepr_account_id", null: false
    t.integer "keepr_journal_id", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.integer "keepr_cost_center_id"
    t.string "accountable_type"
    t.integer "accountable_id"
    t.string "side"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["accountable_type", "accountable_id"], name: "index_keepr_postings_on_accountable_type_and_accountable_id"
    t.index ["keepr_account_id"], name: "index_keepr_postings_on_keepr_account_id"
    t.index ["keepr_cost_center_id"], name: "index_keepr_postings_on_keepr_cost_center_id"
    t.index ["keepr_journal_id"], name: "index_keepr_postings_on_keepr_journal_id"
  end

  create_table "keepr_taxes", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.decimal "value", precision: 8, scale: 2, null: false
    t.integer "keepr_account_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["keepr_account_id"], name: "index_keepr_taxes_on_keepr_account_id"
  end

  create_table "order_versions", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "total_amount_cents", default: 0, null: false
    t.integer "agent_comm", default: 0, null: false
    t.text "version_note"
    t.boolean "final_version", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id", null: false
    t.integer "profit", default: 0, null: false
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
    t.decimal "quantity", precision: 7, scale: 1, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "formula"
    t.decimal "quantity_real", precision: 7, scale: 1, default: "0.0", null: false
    t.decimal "waste", precision: 7, scale: 1, default: "0.0", null: false
    t.decimal "ratio", precision: 3, scale: 2, default: "0.0"
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
    t.integer "price_cents", default: 0, null: false
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
