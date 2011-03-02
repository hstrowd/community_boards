class CreateCommunitiesUsers < ActiveRecord::Migration
  def self.up
    execute "CREATE TABLE communities_users ( user_id integer NOT NULL,
                                              community_id integer NOT NULL,
                                              created_at datetime, 
                                              INDEX (user_id, community_id))"
  end

  def self.down
    drop_table :communities_users
  end
end
