class CreateCommunitiesUsers < ActiveRecord::Migration
  def self.up
    create_table(:communities_users, :id => false) do |t|
      t.integer :user_id, :null => false
      t.integer :community_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :communities_users
  end
end
