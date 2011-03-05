require 'migration_helper'
class CreateUsers < ActiveRecord::Migration
  extend MigrationHelper
  def self.up
    create_table :user_visibilities do |t|
      t.string :name, :null => false
      t.string :description, :null => false
    end

    UserVisibility.new(:name => UserVisibility::Public,
                       :description => 'All other users can find this user, view this user\'s nickname, events, communities, etc, and request their friendship. No restricted information.').save!
    UserVisibility.new(:name => UserVisibility::FriendsOnly,
                       :description => 'All other users can find this user and request their friendship, but only this user\'s friends can view their nickname, events, communities, etc.').save!
    UserVisibility.new(:name => UserVisibility::Private,
                       :description => 'No other users can find this user, view any of their information, or request their friendship.').save!

    create_table :users do |t|
      t.string :email, :null => false
      t.string :password, :null => false
      t.integer :visibility_id, :null => false

      t.timestamps
    end

    add_foreign_key 'users', 'visibility_id', 'user_visibilities'

    create_table :friendship_statuses do |t|
      t.string :name, :null => false
      t.string :description, :null => false
    end

    FriendshipStatus.new(:name => FriendshipStatus::Requested, 
                         :description => 'The friendship has been requested, but not yet accepted.').save!
    FriendshipStatus.new(:name => FriendshipStatus::Accepted, 
                         :description => 'The friendship has been requested and accepted.').save!
    FriendshipStatus.new(:name => FriendshipStatus::Declined, 
                         :description => 'The friendship has been requested, but was declined.').save!
    FriendshipStatus.new(:name => FriendshipStatus::Broken, 
                         :description => 'The friendship has been requested was accepted, but has been broken.').save!

    create_table :friendships do |t|
      t.integer :initiator_id, :null => false
      t.integer :recipient_id, :null => false
      t.integer :status_id, :null => false

      t.timestamps
    end

    add_foreign_key 'friendships', 'initiator_id', 'users'
    add_foreign_key 'friendships', 'recipient_id', 'users'
    add_foreign_key 'friendships', 'status_id', 'friendship_statuses'
  end

  def self.down
    drop_table :users
  end
end
