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

ActiveRecord::Schema[7.0].define(version: 2023_08_06_185640) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "mycelia", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.string "species"
    t.datetime "inoculation_date"
    t.bigint "strain_source_id"
    t.integer "generation"
    t.string "external_provider"
    t.string "substrate"
    t.string "container"
    t.string "strain_description"
    t.integer "shelf_time"
    t.string "image_url"
    t.float "weight"
    t.string "prefix"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id", null: false
    t.bigint "room_id"
    t.index ["organization_id"], name: "index_mycelia_on_organization_id"
    t.index ["room_id"], name: "index_mycelia_on_room_id"
    t.index ["strain_source_id"], name: "index_mycelia_on_strain_source_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_code"
    t.datetime "invitation_code_expires_at"
    t.datetime "invitation_code_created_at"
    t.index ["name"], name: "index_organizations_on_name", unique: true
  end

  create_table "prefix_counts", force: :cascade do |t|
    t.string "prefix", null: false
    t.integer "count", default: 0, null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_prefix_counts_on_organization_id"
    t.index ["prefix", "organization_id"], name: "index_prefix_counts_on_prefix_and_organization_id", unique: true
  end

  create_table "room_inspections", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.float "humidity"
    t.float "temperature"
    t.float "co_2"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_room_inspections_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id", null: false
    t.index ["organization_id"], name: "index_rooms_on_organization_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.bigint "organization_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "mycelia", "mycelia", column: "strain_source_id"
  add_foreign_key "mycelia", "organizations"
  add_foreign_key "mycelia", "rooms"
  add_foreign_key "prefix_counts", "organizations"
  add_foreign_key "room_inspections", "rooms"
  add_foreign_key "rooms", "organizations"
end
