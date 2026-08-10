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

ActiveRecord::Schema[8.1].define(version: 2026_08_09_165932) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "author", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_books_on_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "librarians", force: :cascade do |t|
    t.string "auth_token"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.boolean "must_change_password", default: false, null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["auth_token"], name: "index_librarians_on_auth_token", unique: true
    t.index ["email"], name: "index_librarians_on_email", unique: true
  end

  create_table "library_users", force: :cascade do |t|
    t.string "cpf", null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "full_name", null: false
    t.string "loan_password_digest", null: false
    t.string "phone", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_library_users_on_cpf", unique: true
    t.index ["email"], name: "index_library_users_on_email", unique: true
  end

  create_table "loans", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.date "due_date", null: false
    t.bigint "librarian_id", null: false
    t.bigint "library_user_id", null: false
    t.date "loan_date", null: false
    t.date "return_date"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_loans_on_book_id"
    t.index ["due_date"], name: "index_loans_on_due_date"
    t.index ["librarian_id"], name: "index_loans_on_librarian_id"
    t.index ["library_user_id"], name: "index_loans_on_library_user_id"
    t.index ["status"], name: "index_loans_on_status"
  end

  add_foreign_key "books", "categories"
  add_foreign_key "loans", "books"
  add_foreign_key "loans", "librarians"
  add_foreign_key "loans", "library_users"
end
