require 'migration_helper'
class CreateCommunities < ActiveRecord::Migration
  extend MigrationHelper
  def self.up
    create_table :communities do |t|
      t.string :name, :null => false
      t.integer :location_id

      t.timestamps
    end

    add_foreign_key 'communities', 'location_id', 'locations'
  end

  def self.down
    drop_table :communities
  end
end
