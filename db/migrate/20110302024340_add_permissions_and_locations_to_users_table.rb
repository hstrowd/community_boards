require 'migration_helper'
class AddPermissionsAndLocationsToUsersTable < ActiveRecord::Migration
  extend MigrationHelper
  def self.up
    add_column :users, :permission_id, :integer, :null => false
    add_foreign_key 'users', 'permission_id', 'permissions'

    add_column :users, :location_id, :integer
    add_foreign_key 'users', 'location_id', 'locations'

    email = EmailAddress.new(:email => 'admin@eventhub.com')
    email.save!

    admin = User.new(:username => 'eh_admin', 
                     :password => 'admin1234!', 
                     :primary_email => email,
                     :permission => Permission.admin,
                     :visibility => UserVisibility.private)
    admin.save!

    email.user = admin
    email.save!
  end

  def self.down
    admin_user = User.find_by_email_and_password('admin@commboards.com', 'admin1')
    admin_user && admin_user.destroy

    drop_foreign_key 'users', 'permission_id'
    
    remove_column :users, :role_id
  end
end
