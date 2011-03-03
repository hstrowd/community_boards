class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.text :name, :null => false
      t.text :description, :null => false

      t.timestamps
    end

    Permission.new({:name => 'admin', :description => 'Site Administrator'}).save!
    Permission.new({:name => 'regulator', :description => 'Content Regulator'}).save!
    Permission.new({:name => 'user', :description => 'Standard User'}).save!
  end

  def self.down
    drop_table :permissions
  end
end
