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

ActiveRecord::Schema.define(:version => 20110303010933) do

  create_table "communities", :force => true do |t|
    t.string   "name",        :null => false
    t.integer  "location_id"
    t.integer  "type_id",     :null => false
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "communities", ["creator_id"], :name => "fk_communities_creator_id"
  add_index "communities", ["location_id"], :name => "fk_communities_location_id"

  create_table "community_members", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.integer  "community_id", :null => false
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "community_members", ["community_id"], :name => "fk_community_members_community_id"
  add_index "community_members", ["user_id"], :name => "fk_community_members_user_id"

  create_table "community_roles", :force => true do |t|
    t.string "name",        :null => false
    t.string "description", :null => false
  end

  create_table "community_types", :force => true do |t|
    t.string "name",        :null => false
    t.string "description", :null => false
  end

  create_table "event_attendance_statuses", :force => true do |t|
    t.string "status",      :null => false
    t.string "description", :null => false
  end

  create_table "event_attendances", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "event_id",   :null => false
    t.integer  "status_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_attendances", ["event_id"], :name => "fk_event_attendances_event_id"
  add_index "event_attendances", ["status_id"], :name => "fk_event_attendances_status_id"
  add_index "event_attendances", ["user_id"], :name => "fk_event_attendances_user_id"

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

  create_table "friendship_statuses", :force => true do |t|
    t.string "name",        :null => false
    t.string "description", :null => false
  end

  create_table "friendships", :force => true do |t|
    t.integer  "initiator_id", :null => false
    t.integer  "recipient_id", :null => false
    t.integer  "status_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["initiator_id"], :name => "fk_friendships_initiator_id"
  add_index "friendships", ["recipient_id"], :name => "fk_friendships_recipient_id"
  add_index "friendships", ["status_id"], :name => "fk_friendships_status_id"

  create_table "locations", :force => true do |t|
    t.string   "country_cd", :limit => 3, :null => false
    t.string   "state_cd",   :limit => 5, :null => false
    t.string   "city",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["country_cd", "state_cd", "city"], :name => "unique_contry_state_city", :unique => true
  add_index "locations", ["id"], :name => "id"

  create_table "permissions", :force => true do |t|
    t.text     "name",        :null => false
    t.text     "description", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_visibilities", :force => true do |t|
    t.string "name",        :null => false
    t.string "description", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",         :null => false
    t.string   "password",      :null => false
    t.integer  "visibility_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "permission_id", :null => false
    t.integer  "location_id"
  end

  add_index "users", ["location_id"], :name => "fk_users_location_id"
  add_index "users", ["permission_id"], :name => "fk_users_permission_id"
  add_index "users", ["visibility_id"], :name => "fk_users_visibility_id"

end
