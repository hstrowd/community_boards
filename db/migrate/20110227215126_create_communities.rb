require 'migration_helper'
class CreateCommunities < ActiveRecord::Migration
  extend MigrationHelper
  def self.up
    create_table :community_visibilities do |t|
      t.string :name, :null => false
      t.string :description, :null => false
    end

    CommunityVisibility.new(:name => CommunityVisibility::Public,
                            :description => 'A community that can be seen and joined by any user.').save!
    CommunityVisibility.new(:name => CommunityVisibility::Private,
                            :description => 'A community that can only be seen and joined users that have been invited by an owner of the community.').save!

    create_table :communities do |t|
      t.string :name, :null => false
      t.integer :location_id
      t.integer :visibility_id, :null => false
      t.integer :creator_id

      t.timestamps
    end

    add_foreign_key 'communities', 'creator_id', 'users'
    add_foreign_key 'communities', 'location_id', 'locations'
    add_foreign_key 'communities', 'visibility_id', 'community_visibilities'
  end

  def self.down
    drop_table :communities
  end
end
