require 'migration_helper'
class CreateEvents < ActiveRecord::Migration
  extend MigrationHelper

  def self.up
    create_table :event_visibilities do |t|
      t.string :name, :null => false
      t.string :description, :null => false
    end

    EventVisibility.new(:name => EventVisibility::Public,
                        :description => 'All users can find this event, view it\'s details, and attend it. No restrictions.').save!
    EventVisibility.new(:name => EventVisibility::Private,
                        :description => 'Only invited users can find this event, view it\'s details, and attend it.').save!


    create_table :events do |t|
      t.string :title, :null => false
      t.text :description, :null => false
      t.integer :community_id, :null => false
      t.integer :creator_id, :null => false
      t.integer :visibility_id, :null => false
      t.datetime :start_time
      t.datetime :end_time
      t.float :cost

      t.timestamps
    end

    add_foreign_key 'events', 'community_id', 'communities'
    add_foreign_key 'events', 'creator_id', 'users'
    add_foreign_key 'events', 'visibility_id', 'event_visibilities'


    create_table :event_planners do |t|
      t.integer :user_id, :null => false
      t.integer :event_id, :null => false
      t.integer :appointer_id, :null => false

      t.timestamps
    end

    add_foreign_key 'event_planners', 'user_id', 'users'
    add_foreign_key 'event_planners', 'event_id', 'events'
    add_foreign_key 'event_planners', 'appointer_id', 'users'
  end

  def self.down
    drop_table :events
  end
end
