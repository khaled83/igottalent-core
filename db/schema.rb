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

ActiveRecord::Schema.define(version: 2018_06_05_110407) do

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "facebook_id"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
  end

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.string "genre"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved_admin", default: false
    t.integer "user_id"
    t.string "video_id"
    t.boolean "approved_user"
    t.boolean "live", default: false
    t.index ["live"], name: "index_videos_on_live"
    t.index ["user_id"], name: "index_videos_on_user_id"
  end

end
