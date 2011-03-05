class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.text :name, :null => false
      t.text :description, :null => false

      t.timestamps
    end

    Permission.new(:name => Permission::Admin, 
                   :description => 'Site Administrator').save!
    Permission.new(:name => Permission::Regulator, 
                   :description => 'Content Regulator').save!
    Permission.new(:name => Permission::User, 
                   :description => 'Standard User').save!
  end

  def self.down
    drop_table :permissions
  end
end
