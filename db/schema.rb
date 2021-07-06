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

ActiveRecord::Schema.define(version: 2021_07_06_084905) do

  create_table "active_storage_attachments", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "brands", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_brands_on_name", unique: true
  end

  create_table "colors", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_colors_on_name", unique: true
  end

  create_table "employees", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id", null: false
    t.bigint "stores_id", null: false
    t.index ["stores_id"], name: "index_employees_on_stores_id"
    t.index ["users_id"], name: "index_employees_on_users_id"
  end

  create_table "models", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "operating_systems_id", null: false
    t.bigint "brands_id", null: false
    t.index ["brands_id"], name: "index_models_on_brands_id"
    t.index ["name"], name: "index_models_on_name", unique: true
    t.index ["operating_systems_id"], name: "index_models_on_operating_systems_id"
  end

  create_table "operating_systems", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_operating_systems_on_name", unique: true
  end

  create_table "phones", charset: "utf8mb4", force: :cascade do |t|
    t.integer "manufacture_year", null: false
    t.string "condition", null: false
    t.integer "memory", null: false
    t.float "price", null: false
    t.text "note"
    t.string "status", default: "in_stock", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "models_id", null: false
    t.bigint "stores_id", null: false
    t.bigint "colors_id", null: false
    t.index ["colors_id"], name: "index_phones_on_colors_id"
    t.index ["models_id"], name: "index_phones_on_models_id"
    t.index ["stores_id"], name: "index_phones_on_stores_id"
  end

  create_table "stores", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "location"
    t.bigint "users_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_stores_on_name", unique: true
    t.index ["users_id"], name: "index_stores_on_users_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.string "phone"
    t.string "role", default: "admin", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "employees", "stores", column: "stores_id"
  add_foreign_key "employees", "users", column: "users_id"
  add_foreign_key "models", "brands", column: "brands_id"
  add_foreign_key "models", "operating_systems", column: "operating_systems_id"
  add_foreign_key "phones", "colors", column: "colors_id"
  add_foreign_key "phones", "models", column: "models_id"
  add_foreign_key "phones", "stores", column: "stores_id"
  add_foreign_key "stores", "users", column: "users_id"
end
