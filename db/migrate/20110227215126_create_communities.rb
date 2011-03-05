require 'migration_helper'
class CreateCommunities < ActiveRecord::Migration
  extend MigrationHelper
  def self.up
    create_table :community_types do |t|
      t.string :name, :null => false
      t.string :description, :null => false
    end

    CommunityType.new(:name => CommunityType::Public,
                      :description => 'A community that can be seen and joined by any user.').save!
    CommunityType.new(:name => CommunityType::Private,
                      :description => 'A community that can only be seen and joined users that have been invited by an owner of the community.').save!

    create_table :communities do |t|
      t.string :name, :null => false
      t.integer :location_id
      t.integer :type_id, :null => false
      t.integer :creator_id

      t.timestamps
    end

    add_foreign_key 'communities', 'creator_id', 'users'
    add_foreign_key 'communities', 'location_id', 'locations'
  end

  def self.down
    drop_table :communities
  end
end
