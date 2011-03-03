require 'migration_helper'
class CreateEvents < ActiveRecord::Migration
  extend MigrationHelper

  def self.up
    create_table :events do |t|
      t.string :title, :null => false
      t.text :description, :null => false
      t.integer :community_id, :null => false
      t.datetime :start_time
      t.datetime :end_time
      t.float :cost

      t.timestamps
    end

    add_foreign_key 'events', 'community_id', 'communities'
  end

  def self.down
    drop_table :events
  end
end
