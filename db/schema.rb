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

ActiveRecord::Schema.define(:version => 20110302024340) do

  create_table "communities", :force => true do |t|
    t.string   "name",        :null => false
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "communities", ["location_id"], :name => "fk_communities_location_id"

  create_table "communities_users", :id => false, :force => true do |t|
    t.integer  "user_id",      :null => false
    t.integer  "community_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "title",        :null => false
    t.text     "description",  :null => false
    t.integer  "community_id", :null => false
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["community_id"], :name => "fk_events_community_id"

  create_table "locations", :force => true do |t|
    t.string   "country_cd", :limit => 3, :null => false
    t.string   "state_cd",   :limit => 5, :null => false
    t.string   "city",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["country_cd", "state_cd", "city"], :name => "unique_contry_state_city", :unique => true
  add_index "locations", ["id"], :name => "id"

  create_table "roles", :force => true do |t|
    t.text     "name",        :null => false
    t.text     "description", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",      :null => false
    t.string   "password",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id",    :null => false
  end

  add_index "users", ["role_id"], :name => "fk_users_role_id"

end
