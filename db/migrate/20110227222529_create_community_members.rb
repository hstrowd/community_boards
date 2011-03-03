require 'migration_helper'
class CreateCommunityMembers < ActiveRecord::Migration
  extend MigrationHelper
  def self.up
    create_table :community_members do |t|
      t.integer :user_id, :null => false
      t.integer :community_id, :null => false

      t.timestamps
    end

    add_foreign_key 'community_members', 'user_id', 'users'
    add_foreign_key 'community_members', 'community_id', 'communities'
  end

  def self.down
    drop_table :communities_users
  end
end
