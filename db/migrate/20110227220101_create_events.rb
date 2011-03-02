class CreateEvents < ActiveRecord::Migration
  def self.up
    execute "CREATE TABLE events ( id integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                   title varchar(255) NOT NULL,
                                   description text NOT NULL,
                                   community_id integer NOT NULL,
                                   start_time datetime,
                                   end_time datetime,
                                   cost integer,
                                   created_at datetime, 
                                   updated_at datetime, 
                                   INDEX (id),
                                   FOREIGN KEY INDEX_communtiy_id (community_id) 
                                               REFERENCES communities (id))"
  end

  def self.down
    drop_table :events
  end
end
