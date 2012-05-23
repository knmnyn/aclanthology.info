# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120202084715) do

  create_table "affiliations", :force => true do |t|
    t.integer "person_id"
    t.string  "institution"
    t.date    "start_date"
    t.date    "end_date"
    t.string  "position"
  end

  create_table "authorships", :force => true do |t|
    t.integer "paper_id"
    t.integer "person_id"
    t.integer "position"
  end

  add_index "authorships", ["paper_id"], :name => "index_authorships_on_paper_id"
  add_index "authorships", ["person_id"], :name => "index_authorships_on_person_id"

  create_table "bookmarks", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "document_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type"
  end

  create_table "editorships", :force => true do |t|
    t.integer  "volume_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "editorships", ["person_id"], :name => "index_editorships_on_person_id"
  add_index "editorships", ["volume_id"], :name => "index_editorships_on_volume_id"

  create_table "event_series", :force => true do |t|
    t.string "acronym"
  end

  create_table "events", :force => true do |t|
    t.string  "name"
    t.text    "intro"
    t.integer "event_serie_id"
    t.boolean "kind",           :default => true
    t.string  "event_id"
    t.string  "bibkey"
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.integer  "paper_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "papers", :force => true do |t|
    t.string   "title"
    t.datetime "pubdate"
    t.string   "address"
    t.string   "publisher"
    t.string   "url"
    t.string   "bibtype"
    t.string   "bibkey"
    t.string   "pages"
    t.string   "volume_id"
    t.string   "kind"
    t.string   "languages_processed"
    t.string   "anthology_id"
    t.string   "doi"
    t.string   "acmsearch"
    t.string   "event_id"
    t.string   "software"
    t.string   "dataset"
    t.string   "year"
    t.string   "attachment"
  end

  add_index "papers", ["volume_id"], :name => "index_papers_on_volume_id"

  create_table "people", :force => true do |t|
    t.string "first_name"
    t.string "last_name"
  end

  create_table "searches", :force => true do |t|
    t.text     "query_params"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type"
  end

  add_index "searches", ["user_id"], :name => "index_searches_on_user_id"

  create_table "siggroups", :force => true do |t|
    t.string   "name"
    t.string   "sigid"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsors", :force => true do |t|
    t.string   "name"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "urls", :force => true do |t|
    t.integer  "paper_id"
    t.string   "url_type"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "volumes", :force => true do |t|
    t.string  "number"
    t.string  "title"
    t.integer "event_id"
    t.string  "address"
    t.date    "pubdate"
    t.string  "publisher"
    t.string  "url"
    t.string  "bibtype"
    t.string  "bibkey"
    t.string  "anthology_id"
    t.string  "sigid"
    t.string  "year"
  end

end
