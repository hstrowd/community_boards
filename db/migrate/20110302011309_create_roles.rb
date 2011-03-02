class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.text :name, :null => false
      t.text :description, :null => false

      t.timestamps
    end

    Role.new({:name => 'admin', :description => 'Site Administrator'}).save!
    Role.new({:name => 'regulator', :description => 'Content Regulator'}).save!
    Role.new({:name => 'user', :description => 'Standard User'}).save!
  end

  def self.down
    drop_table :roles
  end
end
