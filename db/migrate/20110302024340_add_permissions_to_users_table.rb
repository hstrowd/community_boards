require 'migration_helper'
class AddPermissionsToUsersTable < ActiveRecord::Migration
  extend MigrationHelper

  def self.up
    add_column :users, :permission_id, :integer, :null => false

    add_foreign_key 'users', 'permission_id', 'permissions'

    User.new({ :email => 'admin@commboards.com', 
               :password => 'admin1', 
               :permission_id => 1 }).save!
  end

  def self.down
    admin_user = User.find_by_email_and_password('admin@commboards.com', 'admin1')
    admin_user && admin_user.destroy

    drop_foreign_key 'users', 'permission_id'
    
    remove_column :users, :role_id
  end
end
