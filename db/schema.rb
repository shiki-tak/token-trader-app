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

ActiveRecord::Schema.define(version: 20171013082445) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hashedusers", force: :cascade do |t|
    t.string   "hashed_username"
    t.string   "ether_account"
    t.string   "ether_account_password"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "posessions", force: :cascade do |t|
    t.string   "user_id"
    t.string   "token_id"
    t.decimal  "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "name"
    t.string   "symbol"
    t.decimal  "totalTokens"
    t.decimal  "balanceTokens"
    t.string   "token_address"
    t.string   "owner_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "trades", force: :cascade do |t|
    t.decimal  "price"
    t.string   "from_token_name"
    t.string   "to_token_name"
    t.decimal  "from_token_amount"
    t.decimal  "to_token_amount"
    t.string   "maker_address"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",               default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

end
