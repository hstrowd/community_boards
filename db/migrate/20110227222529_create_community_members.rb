require 'migration_helper'
class CreateCommunityMembers < ActiveRecord::Migration
  extend MigrationHelper
  def self.up
    create_table :community_roles do |t|
      t.string :name, :null => false
      t.string :description, :null => false
    end

    CommunityRole.new(:name => CommunityRole::Creator,
                      :description => 'The community member who initially created this community. There is a max of 1 creator per community and that user will never change.').save!
    CommunityRole.new(:name => CommunityRole::Owner,
                      :description => 'A community member with the ability to modify the information about a community and invite members to private communities.').save!

    create_table :community_members do |t|
      t.integer :user_id, :null => false
      t.integer :community_id, :null => false
      t.integer :role_id

      t.timestamps
    end

    add_foreign_key 'community_members', 'user_id', 'users'
    add_foreign_key 'community_members', 'community_id', 'communities'
  end

  def self.down
    drop_table :communities_users
  end
end
