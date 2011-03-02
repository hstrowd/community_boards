class CreateCommunities < ActiveRecord::Migration
  def self.up
    execute "CREATE TABLE communities ( id integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                        name varchar(255) NOT NULL,
                                        location_id integer,
                                        created_at datetime, 
                                        updated_at datetime, 
                                        INDEX (id),
                                        FOREIGN KEY INDEX_location_id (location_id) 
                                                    REFERENCES locations (id))"
  end

  def self.down
    drop_table :communities
  end
end
